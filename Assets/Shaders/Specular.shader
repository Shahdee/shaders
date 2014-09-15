﻿Shader "Custom/Specular" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Power("pow", Range(0,1)) =0.5
		_Tint("Tint", Color) = (1,1,1,1)
		_SpecColor("Color", Color) = (1,1,1,1)

	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf BlinnPhong

		sampler2D _MainTex;
		float4 _Tint;
		float _Power;

		struct Input {
			float2 uv_MainTex;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			
			half4 c = tex2D (_MainTex, IN.uv_MainTex)*_Tint;
			o.Specular = _Power;
			o.Gloss = 1.0;
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
