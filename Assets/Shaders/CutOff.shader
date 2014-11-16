﻿Shader "Custom/CutOff" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_CutOff("Cut value", Range(0,1)) = 0.5
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert alphatest:_CutOff

		sampler2D _MainTex;

		struct Input {
			float2 uv_MainTex;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			half4 c = tex2D (_MainTex, IN.uv_MainTex);
			o.Albedo = c.rgb;
			o.Alpha = c.r;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
