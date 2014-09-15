Shader "Custom/CubeMapHelper" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Tint("Tint", Color) = (1,1,1,1)
		_Cubemap("Cubemap", CUBE) = ""{}
		_ReflAmount("Ref amount", Range(0.01, 1)) = 0.5
		_ReflMask("Refl mask", 2D) = ""{}
		_NormalMap("Normal map", 2D) =""{}
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert

		sampler2D _MainTex;
		sampler2D _ReflMask;
		samplerCUBE _Cubemap;
		sampler2D _NormalMap;
		float4 _Tint;
		float _ReflAmount;

		struct Input {
			float2 uv_MainTex;
			float2 uv_ReflMask;
			float2 uv_NormalMap;
			float3 worldRefl;
			INTERNAL_DATA
		};

		void surf (Input IN, inout SurfaceOutput o) {
			
			half4 c = tex2D (_MainTex, IN.uv_MainTex);

			float3 normal = UnpackNormal(tex2D(_NormalMap, IN.uv_NormalMap)).rgb;

			//float3 reflection = texCUBE(_Cubemap, IN.worldRefl).rgb;
			//float4 reflMask = tex2D(_ReflMask, IN.uv_ReflMask);
			
			o.Normal = normal;
			o.Albedo = c.rgb*_Tint;
			//o.Emission = (reflMask.r*reflection)*_ReflAmount;
			o.Emission = texCUBE(_Cubemap, WorldReflectionVector(IN, o.Normal)).rgb * _ReflAmount;
			o.Alpha = c.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
