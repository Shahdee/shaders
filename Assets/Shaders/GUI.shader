Shader "Custom/GUI" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_GUITint("GUI Tint", Color) = (1,1,1,1)
		_GUIFade("Fade", Range(0,1)) = 0.5
	}
	SubShader {
		Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent" }
		ZWrite off
		Cull back
		LOD 200
		
		CGPROGRAM
		#pragma surface surf UnlitGUI alpha novertexlights

		sampler2D _MainTex;
		float4 _GUITint;
		float _GUIFade;

		struct Input {
			float2 uv_MainTex;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			half4 c = tex2D (_MainTex, IN.uv_MainTex);
			o.Albedo = c.rgb*_GUITint.rgb;
			o.Alpha = c.a*_GUIFade;
		}

		inline fixed4 LightingUnlitGUI (SurfaceOutput s, fixed3 lightDir, fixed3 viewDir, fixed atten)
		{
			fixed4 c;
			c.rgb = s.Albedo;
			c.a = s.Alpha;
			return c;
		}

		ENDCG
	} 
	FallBack "Diffuse"
}
