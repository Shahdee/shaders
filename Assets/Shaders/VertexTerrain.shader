Shader "Custom/VertexTerrain" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_SecTex("Sec (RGB)", 2D) = "white"{}
		_HeightMap("Heightmap (RGB)", 2D) = "white"{}
		_Value("Value", Range(1,20)) = 12
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert vertex:vert

		sampler2D _MainTex;
		sampler2D _SecTex;
		sampler2D _HeightMap;
		float _Value;

		struct Input {
			float2 uv_MainTex;
			float2 uv_SecTex;
			float3 vertColor;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			half4 base = tex2D (_MainTex, IN.uv_MainTex);
			half4 sec = tex2D (_SecTex, IN.uv_SecTex);
			float4 height = tex2D(_HeightMap, IN.uv_MainTex);

			float red = 1-IN.vertColor.r;
			float rHeight = height.r*red;
			float invHeight = 1-height.r;
			float finalHeight = (invHeight*red)*4;
			float finalBlend = saturate(rHeight+finalHeight);

			float hard = ((1-IN.vertColor.g)*_Value)+1;
			finalBlend = pow(finalBlend, hard);

			float3 finalColor = lerp(base, sec, finalBlend);

			o.Albedo = finalColor;
			o.Alpha = base.a;
		}

		void vert(inout appdata_full v ,out Input o)
		{
			UNITY_INITIALIZE_OUTPUT(Input, o);
			o.vertColor = v.color.rgb;
		}

		ENDCG
	} 
	FallBack "Diffuse"
}
