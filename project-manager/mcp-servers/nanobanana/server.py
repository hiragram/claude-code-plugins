#!/usr/bin/env python3
"""
Nano Banana Pro MCP Server
Gemini 3 Pro Image を使用した画像生成 MCP サーバー
"""

import os
import sys
import json
import base64
import tempfile
from datetime import datetime
from pathlib import Path

from mcp.server import Server
from mcp.server.stdio import stdio_server
from mcp.types import Tool, TextContent, ImageContent

from google import genai
from google.genai import types


# サーバーインスタンス
server = Server("nanobanana")

# Gemini クライアント
client = None


def get_client():
    """Gemini クライアントを取得"""
    global client
    if client is None:
        api_key = os.environ.get("GEMINI_API_KEY")
        if not api_key:
            raise ValueError("GEMINI_API_KEY environment variable is not set")
        client = genai.Client(api_key=api_key)
    return client


def save_image(image, output_dir: str = None) -> str:
    """画像を保存してパスを返す（PIL Image または bytes を受け付ける）"""
    if output_dir is None:
        output_dir = "/tmp/infographics"

    # ディレクトリが存在しない場合は作成
    Path(output_dir).mkdir(parents=True, exist_ok=True)

    timestamp = datetime.now().strftime("%Y%m%d-%H%M%S")
    filename = f"nanobanana-{timestamp}.png"
    filepath = Path(output_dir) / filename

    # PIL Image の場合は save メソッドを使用
    if hasattr(image, 'save'):
        image.save(str(filepath))
    else:
        # bytes の場合は直接書き込み
        with open(filepath, "wb") as f:
            f.write(image)

    return str(filepath)


@server.list_tools()
async def list_tools():
    """利用可能なツール一覧"""
    return [
        Tool(
            name="generate_image",
            description="Nano Banana Pro (Gemini 3 Pro Image) を使用して画像を生成します。日本語テキストのレンダリングに優れています。",
            inputSchema={
                "type": "object",
                "properties": {
                    "prompt": {
                        "type": "string",
                        "description": "生成する画像の説明（日本語可）"
                    },
                    "aspect_ratio": {
                        "type": "string",
                        "description": "アスペクト比: 1:1, 16:9, 9:16, 4:3, 3:4",
                        "default": "1:1"
                    },
                    "image_size": {
                        "type": "string",
                        "description": "画像サイズ: 1K, 2K, 4K",
                        "default": "2K"
                    }
                },
                "required": ["prompt"]
            }
        ),
        Tool(
            name="edit_image",
            description="既存の画像を編集します。",
            inputSchema={
                "type": "object",
                "properties": {
                    "image_path": {
                        "type": "string",
                        "description": "編集する画像のパス"
                    },
                    "prompt": {
                        "type": "string",
                        "description": "編集の指示"
                    }
                },
                "required": ["image_path", "prompt"]
            }
        ),
        Tool(
            name="configure_gemini_token",
            description="Gemini API トークンを設定します。",
            inputSchema={
                "type": "object",
                "properties": {
                    "apiKey": {
                        "type": "string",
                        "description": "Gemini API キー"
                    }
                },
                "required": ["apiKey"]
            }
        ),
        Tool(
            name="get_configuration_status",
            description="Gemini API の設定状態を確認します。",
            inputSchema={
                "type": "object",
                "properties": {}
            }
        )
    ]


@server.call_tool()
async def call_tool(name: str, arguments: dict):
    """ツールの実行"""

    if name == "configure_gemini_token":
        api_key = arguments.get("apiKey")
        os.environ["GEMINI_API_KEY"] = api_key
        global client
        client = None  # 再初期化のためリセット
        return [TextContent(type="text", text="Gemini API token configured successfully.")]

    if name == "get_configuration_status":
        api_key = os.environ.get("GEMINI_API_KEY")
        if api_key:
            masked = api_key[:4] + "..." + api_key[-4:]
            return [TextContent(type="text", text=f"Gemini API is configured. Key: {masked}")]
        else:
            return [TextContent(type="text", text="Gemini API is not configured. Please set GEMINI_API_KEY.")]

    if name == "generate_image":
        prompt = arguments.get("prompt")
        aspect_ratio = arguments.get("aspect_ratio", "1:1")
        image_size = arguments.get("image_size", "2K")

        try:
            gemini_client = get_client()

            response = gemini_client.models.generate_content(
                model="gemini-3-pro-image-preview",
                contents=prompt,
                config=types.GenerateContentConfig(
                    response_modalities=["TEXT", "IMAGE"],
                    image_config=types.ImageConfig(
                        aspect_ratio=aspect_ratio,
                        image_size=image_size
                    )
                )
            )

            result_text = ""
            image_path = None

            for part in response.parts:
                if part.text is not None:
                    result_text += part.text
                elif part.inline_data is not None:
                    image = part.as_image()
                    image_path = save_image(image)

            if image_path:
                return [
                    TextContent(
                        type="text",
                        text=f"🎨 Image generated with Nano Banana Pro (Gemini 3 Pro Image)!\n\n"
                             f"📁 Image saved to: {image_path}\n\n"
                             f"{result_text if result_text else ''}"
                    )
                ]
            else:
                return [TextContent(type="text", text=f"Image generation failed. Response: {result_text}")]

        except Exception as e:
            return [TextContent(type="text", text=f"Error: {str(e)}")]

    if name == "edit_image":
        image_path = arguments.get("image_path")
        prompt = arguments.get("prompt")

        try:
            gemini_client = get_client()

            # 画像を読み込み
            with open(image_path, "rb") as f:
                image_data = f.read()

            image_part = types.Part.from_bytes(
                data=image_data,
                mime_type="image/png"
            )

            response = gemini_client.models.generate_content(
                model="gemini-3-pro-image-preview",
                contents=[image_part, prompt],
                config=types.GenerateContentConfig(
                    response_modalities=["TEXT", "IMAGE"],
                )
            )

            result_text = ""
            new_image_path = None

            for part in response.parts:
                if part.text is not None:
                    result_text += part.text
                elif part.inline_data is not None:
                    image = part.as_image()
                    new_image_path = save_image(image)

            if new_image_path:
                return [
                    TextContent(
                        type="text",
                        text=f"🎨 Image edited with Nano Banana Pro!\n\n"
                             f"📁 Image saved to: {new_image_path}\n\n"
                             f"{result_text if result_text else ''}"
                    )
                ]
            else:
                return [TextContent(type="text", text=f"Image editing failed. Response: {result_text}")]

        except Exception as e:
            return [TextContent(type="text", text=f"Error: {str(e)}")]

    return [TextContent(type="text", text=f"Unknown tool: {name}")]


async def main():
    """メイン関数"""
    async with stdio_server() as (read_stream, write_stream):
        await server.run(
            read_stream,
            write_stream,
            server.create_initialization_options()
        )


if __name__ == "__main__":
    import asyncio
    asyncio.run(main())
