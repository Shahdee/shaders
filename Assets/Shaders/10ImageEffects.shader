Shader "Custom/10ImageEffects" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Lumi("Lumi", Range(0,1)) = 0
	}
	SubShader {
		
		Pass
		{

			CGPROGRAM
			#pragma vertex vert_img
			#pragma fragment frag
			#pragma fragmentoption ARB_precision_hint_fastest
			#include "UnityCG.cginc"

			uniform sampler2D _MainTex;
			fixed _Lumi;

			fixed4 frag (v2f_img i) : COLOR 
			{
				fixed4 renTex = tex2D (_MainTex, i.uv);
				float lumi = 0.3 * renTex.r + 0.56 * renTex.g + 0.114 * renTex.b;
				fixed4 finalColor = lerp (renTex, lumi, _Lumi);
				return finalColor;
			}


			ENDCG
		}
	} 
	FallBack "Diffuse"
}
