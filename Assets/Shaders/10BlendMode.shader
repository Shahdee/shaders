Shader "Custom/10BlendMode" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_BlendTex("Blend (RGB)", 2D) = "white" {}
		_Opacity ("Blend opacity", Range(0,1)) = 0.5
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
		uniform sampler2D _BlendTex;
		fixed _Opacity;

		fixed OverlayBlendMode(fixed basePixel, fixed blendPixel)
		{
			if (basePixel < 0.5)
				return (2*basePixel*blendPixel);
			else
				return (1-2*(1-basePixel)*(1-blendPixel));
		}

		//fixed4 frag(v2f_img i):COLOR
		//{
		//	fixed4 renderTex = tex2D(_MainTex, i.uv);
		//	fixed4 blendTex = tex2D(_BlendTex, i.uv);

		//	//fixed4 multi = renderTex*blendTex;
		//	//fixed4 multi = renderTex + blendTex;
		//	fixed4 blend = (1-((1-renderTex)*(1-blendTex)));
			
		//	//renderTex = lerp(renderTex, multi, _Opacity);
		//	renderTex = lerp(renderTex, blend, _Opacity);
		//	return renderTex;
		//}

		fixed4 frag(v2f_img i):COLOR
		{
			fixed4 renderTex = tex2D(_MainTex, i.uv);
			fixed4 blendTex = tex2D(_BlendTex, i.uv);

			fixed4 blend = renderTex;

			blend.r = OverlayBlendMode(renderTex.r, blendTex.r);
			blend.g = OverlayBlendMode(renderTex.g, blendTex.g);
			blend.b = OverlayBlendMode(renderTex.b, blendTex.b);
			
			renderTex = lerp(renderTex, blend, _Opacity);
			return renderTex;
		}

		ENDCG
		}
	} 
	FallBack "Diffuse"
}
