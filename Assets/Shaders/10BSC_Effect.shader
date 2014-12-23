Shader "Custom/10BSC_Effect" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Bright("Brightness", Range (0,1)) = 1.0
		_Saturate("Saturation", Range(0,1)) = 1.0
		_Contrast("_Contrast", Range(0,1)) = 1.0
	}
	SubShader {

		Pass{
		
		CGPROGRAM
		#pragma vertex vert_img
		#pragma fragment frag
		#pragma fragmentoption ARB_precision_hint_fastest
		#include "UnityCG.cginc"

		uniform sampler2D _MainTex;
		fixed _Bright;
		fixed _Saturate;
		fixed _Contrast;

		float3 ContrastSaturationBrightness(float3 color, float brt, float sat, float con)
		{
			float ALumR = 0.5f;
			float ALumG = 0.5f;
			float ALumB = 0.5f;

			float3 LumCoeff = float3(0.2, 0.7, 0.07);

			float3 ALumin = float3(ALumR, ALumG, ALumB);
			float3 brtColor = color*brt;
			float intensityf = dot(brtColor, LumCoeff);
			float3 intensity = float3(intensityf, intensityf, intensityf);

			float3 satColor = lerp(intensity, brtColor, sat);
			float3 conColor = lerp(ALumin, satColor, con);
			return conColor;
		}

		fixed4 frag(v2f_img i) : COLOR 
		{
			fixed4 renderTex = tex2D(_MainTex, i.uv);
			renderTex.rgb = ContrastSaturationBrightness(renderTex.rgb, _Bright, _Saturate, _Contrast);
			return renderTex;
		}

		ENDCG

		}
	} 
	FallBack "Diffuse"
}
