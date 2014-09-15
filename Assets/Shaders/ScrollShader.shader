Shader "Custom/ScrollShader" 
{
	Properties 
	{
		_MainTex("Texture RGB", 2D) = "white" {}
		_ScrollX ("X scroller", Range(0,10)) = 2
		_ScrollY ("Y scroller", Range(0,10)) = 2
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert

		fixed _ScrollX;
		fixed _ScrollY;

		sampler2D _MainTex;

		struct Input {
			float2 uv_MainTex;
		};

		void surf (Input IN, inout SurfaceOutput o) {

			fixed2 scrolledUV = IN.uv_MainTex;
			fixed xScrollVal = _ScrollX * _Time;
			fixed yScrollVal = _ScrollY * _Time;

			scrolledUV += fixed2(xScrollVal, yScrollVal);

			half4 c = tex2D (_MainTex, scrolledUV);
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
