Shader "Custom/Fresnel" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Tint("Tint", Color) = (1,1,1,1)
		_Cubemap("Cubemap", CUBE) = ""{}
		_RefAmount("Ref amount", Range(0,1)) = 0.5
		_RimPow("Rim pow", Range(0,1)) = 0.5
		_SpecColor("Spec color", Color) = (1,1,1,1)
		_SpecPower("Spec power", Range(0,1)) = 0.5
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf BlinnPhong
		#pragma target 3.0

		sampler2D _MainTex;
		float4 _Tint;
		samplerCUBE _Cubemap;
		float _RefAmount;
		float _RimPow;
		float _SpecPower;

		struct Input {
			float2 uv_MainTex;
			float3 worldRefl;
			float3 viewDir;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			half4 c = tex2D (_MainTex, IN.uv_MainTex);

			float rim = 1.0 - saturate(dot(o.Normal, normalize(IN.viewDir)));
			rim = pow(rim, _RimPow);

			o.Albedo = c.rgb*_Tint;
			o.Emission = texCUBE(_Cubemap, IN.worldRefl).rgb * _RefAmount * rim;
			o.Specular = _SpecPower;
			o.Gloss = 1.0;
			o.Alpha = c.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
