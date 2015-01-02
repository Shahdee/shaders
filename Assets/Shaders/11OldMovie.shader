Shader "Custom/11OldMovie" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Vignette("_Vignette", 2D) = "white" {}
		_Scratches("_Scratches", 2D) = "white" {}
		_Dust("_Dust", 2D) = "white" {}
		_SephiaColor("_SephiaColor", Color) = (1,1,1,1)
		_OldEffectAmount("_OldEffectAmount", Range(0,1.5)) = 0.5 
		_VignetteAmount("_VignetteAmount", Range(0,1)) = 0.5
		_ScratchesXSpeed("_ScratchesXSpeed", Float) = 10.0
		_ScratchesYSpeed("_ScratchesYSpeed", Float) = 10.0
		_DustXSpeed("_DustXSpeed", Float) = 10.0
		_DustYSpeed("_DustYSpeed", Float) = 10.0
		_RandomValue("_RandomValue", Float) = 1.0

	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200

		Pass{
		
			CGPROGRAM
			#pragma vertex vert_img
			#pragma fragment frag
			#pragma fragmentoption ARB_preciosion_fastest
			#include "UnityCG.cginc"

			uniform sampler2D _MainTex;
			uniform sampler2D _Vignette;
			uniform sampler2D _Scratches;
			uniform sampler2D _Dust;

			fixed4 _SephiaColor;
			fixed  vignetteTex;
			fixed  _OldEffectAmount;
			fixed  _VignetteAmount;
			fixed  _ScratchesXSpeed;
			fixed  _ScratchesYSpeed;
			fixed  _DustXSpeed;
			fixed  _DustYSpeed;
			fixed  _RandomValue;

			struct Input {
				float2 uv_MainTex;
			};

			fixed4 frag(v2f_img i):COLOR
			{
				half2 renderTexUV = half2(i.uv.x, i.uv.y + (_RandomValue*_SinTime.z*0.005));
				fixed4 renderTex = tex2D(_MainTex, renderTexUV);
				fixed4 vignetteTex = tex2D(_Vignette, i.uv);

				half2 scratchesTexUV = half2(i.uv.x + (_RandomValue * _SinTime.z * _ScratchesXSpeed), i.uv.y + (_Time.x * _ScratchesYSpeed)) ;
				fixed4 scratchesTex = tex2D(_Scratches, scratchesTexUV);

				half2 dustTexUV = half2(i.uv.x + (_RandomValue * _SinTime.z * _DustXSpeed), i.uv.y + (_RandomValue * _SinTime.z * _DustYSpeed)) ;
				fixed4 dustTex = tex2D(_Dust, dustTexUV);

				fixed lum = dot(fixed3(0.3, 0.6, 0.1), renderTex.rgb);
				fixed4 finalColor = lum + lerp(_SephiaColor, _SephiaColor + fixed4(0.1, 0.1, 0.1, 0.1), _RandomValue);

				fixed3 constWhite = fixed3(1,1,1);
				finalColor = lerp(finalColor, finalColor*vignetteTex, _VignetteAmount);
				finalColor.rgb *= lerp(scratchesTex, constWhite, _RandomValue); 
				finalColor.rgb *= lerp(dustTex.rgb, constWhite, _RandomValue*_SinTime.z);
				finalColor = lerp(renderTex, finalColor, _OldEffectAmount);
				return finalColor;
			}

			ENDCG
		}
	} 
	FallBack "Diffuse"
}
