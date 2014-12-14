Shader "Custom/9CGInclude" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Desat ("Desat", Range(0,1)) = 0.5 
		_MyColor("Color", Color) = (1,1,1,1)
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#define HalfLambert
		#include "ShahdeeCGInclude.cginc"
		#pragma surface surf CustomLambert

		sampler2D _MainTex;
		fixed _Desat;

		struct Input {
			float2 uv_MainTex;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			half4 c = tex2D (_MainTex, IN.uv_MainTex);
			c.rgb = lerp(c.rgb, Luminance(c.rgb), _Desat);
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
