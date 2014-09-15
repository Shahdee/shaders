Shader "Custom/Levels" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Black("Black", Range(0,255)) = 0
		_Gamma("Gamma", Range(0,2)) = 1.8
		_White("White", Range(0,255)) = 255

		_BlackOut("Black out", Range(0,255)) = 255
		_WhiteOut("White out", Range(0,2)) = 0
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert

		sampler2D _MainTex;
		float _Black;
		float _BlackOut;
		float _White;
		float _WhiteOut;
		float _Gamma;

		struct Input {
			float2 uv_MainTex;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			half4 c = tex2D (_MainTex, IN.uv_MainTex);
			float outRPixel = (c.r*255.0);
			outRPixel = max(0, outRPixel - _Black);
			outRPixel = saturate(pow(outRPixel/(_White-_Black), _Gamma));
			outRPixel = (outRPixel*(_WhiteOut - _BlackOut) + _BlackOut)/255.0;
			c.r = outRPixel;
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
