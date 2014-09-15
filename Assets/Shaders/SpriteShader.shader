Shader "Custom/SpriteShader" {
	Properties {

		_MainTex ("Base (RGB)", 2D) = "white" {}
		_TexWidth("Texture width", float) = 918
		_TexHeight("Texture height", float) = 506
		_CellAmountX("Cell amount X", float) = 5
		_CellAmountY("Cell amount Y", float) = 3
		_Speed("Speed", Range(1,32)) = 5
	}
	SubShader {

		Tags { "RenderType"="Opaque" }
		LOD 200

		CGPROGRAM
		#pragma surface surf Lambert alpha
		#pragma debug

		sampler2D _MainTex;
		float _TexWidth;
		float _TexHeight;
		float _CellAmountX;
		float _CellAmountY;
		float _Speed;

		struct Input {
			float2 uv_MainTex;
		};

		void surf (Input IN, inout SurfaceOutput o) {

			float2 spriteUV = IN.uv_MainTex;
			float cellPercX =  1 / _CellAmountX;
			float cellPercY = 1 /_CellAmountY;
			float time = _Time.y*_Speed;
			float cell = fmod(time, _CellAmountX*_CellAmountY-1);
			cell = floor(cell);
			float x = fmod(cell, _CellAmountX);
			float y = floor(cell/_CellAmountX);
			float xValue = spriteUV.x;
			xValue += x;
			xValue *=cellPercX;
			float yValue = spriteUV.y; 
			yValue += (_CellAmountY - 1) - y;
			yValue *= cellPercY;
			spriteUV = float2(xValue, yValue);
			half4 c = tex2D (_MainTex, spriteUV);

			o.Alpha = c.a;
			o.Albedo = c.rgb;
		}
		ENDCG
		
	} 
	FallBack "Diffuse"
}
