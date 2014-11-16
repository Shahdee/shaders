Shader "Custom/Transparent" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_TransValue("TransValue", Range(0,1)) = 0.5

	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert alpha

		sampler2D _MainTex;
		float _TransValue;

		struct Input {
			float2 uv_MainTex;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			half4 c = tex2D (_MainTex, IN.uv_MainTex);
			o.Albedo = c.rgb;
			o.Alpha = c.g*_TransValue;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
