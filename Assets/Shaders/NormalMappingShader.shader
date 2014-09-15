Shader "Custom/NormalMappingShader" {
	Properties {
		_Tint("Tint", Color) = (1,1,1,1)
		_MainTex("Main texture", 2D) ="white" {}
		_Normal ("Normal map", 2D) = "bump" {}
		_NormIntensity("Intensity", Range(0,5)) = 1
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert

		sampler2D _Normal, _MainTex;
		float4 _Tint;
		float _NormIntensity;

		struct Input {
			float2 uv_Normal;
			float2 uv_MainTex;
		};

		void surf (Input IN, inout SurfaceOutput o) {

			float4 c = tex2D(_MainTex, IN.uv_MainTex);
			float3 normal = UnpackNormal(tex2D(_Normal, IN.uv_Normal));
			normal = float3(normal.x*_NormIntensity, normal.y*_NormIntensity, normal.z*_NormIntensity);

			o.Albedo = c.rgb;
			o.Alpha = c.a;
			o.Normal = normal.rgb;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
