Shader "Custom/11NightVision" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Contrast ("_Contrast", Range(0,4)) = 2
		_Brightness ("_Brightness", Range(0,2)) = 1
		_NightVisColor ("_NightVisColor", Color) = (1,1,1,1)
		_Vignette ("_Vignette", 2D) = "white" {}
		_Stripes ("_Stripes", 2D) = "white" {}
		_StripesTileAmount ("_StripesTileAmount", Float) = 4.0
		_Noise ("_Noise", 2D) = "white" {}
		_NoiseXSpeed ("_NoiseXSpeed", Float) = 100.0
		_NoiseYSpeed ("_NoiseYSpeed", Float) = 100.0
		_Distortion ("_Distortion", Float) = 0.2 
		_Scale ("_Scale", Float) = 0.8 
		_Random ("_Random", Float) = 0 
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200

		Pass{
			CGPROGRAM
			#pragma vertex vert_img
			#pragma fragment frag
			#pragma fragmentoption ARB_preciosion_hint_fastest
			#include "UnityCG.cginc"

			uniform sampler2D _MainTex;
			uniform sampler2D _Vignette;
			uniform sampler2D _Stripes;
			uniform sampler2D _Noise;
			fixed4 _NightVisColor;
			fixed _Contrast;
			fixed _StripesTileAmount;
			fixed _Brightness;
			fixed _Random;
			fixed _NoiseXSpeed;
			fixed _NoiseYSpeed;
			fixed _Distortion;
			fixed _Scale;

			struct Input {
				float2 uv_MainTex;
			};

			float2 BarrelDist(float2 coord)
			{
				float2 h = coord.xy - float2(0.5, 0.5);
				float r2 = h.x * h.x + h.y * h.y;
				float f = 1.0 + r2 * (_Distortion * sqrt(r2));
				return f*_Scale*h + 0.5;
			}

			fixed4 frag(v2f_img i):COLOR
			{
				half2 distUV = BarrelDist(i.uv);
				fixed4 renderTex = tex2D(_MainTex, distUV);
				fixed4 vignetteTex = tex2D(_Vignette, i.uv);

				half2 stripesUV = half2(i.uv.x * _StripesTileAmount, i.uv.y * _StripesTileAmount);
				fixed4 stripesTex = tex2D(_Stripes, stripesUV);

				half2 noiseUV = half2(i.uv.x + (_Random * _SinTime.z * _NoiseXSpeed), i.uv.y + (_Time.z * _NoiseYSpeed));
				fixed4 noiseTex = tex2D(_Noise, noiseUV);

				fixed lum = dot(fixed3(0.3, 0.6f, 0.1f), renderTex.rgb);
				lum += _Brightness;
				fixed4 finalCol = (lum*2) + _NightVisColor;

				finalCol = pow(finalCol, _Contrast);
				finalCol *= vignetteTex;
				finalCol *= stripesTex*noiseTex;
				return finalCol;
			}
			ENDCG
		}
	} 
	FallBack "Diffuse"
}
