Shader "Custom/Convol" {
	Properties {
		_Tint("Tint", Color) = (1,1,1,1)
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_AOMap ("Ambient oclussion map", 2D) = "white" {}
		_BumpMap ("Bumpmap", 2D) = "bump" {}
		_CubeMap ("Cubemap", Cube) = "" {}
		_SpecIntensity("Spec intensity", Range(0,1)) = 0.1
		_SpecWidth("Spec width", Range(0,1)) = 0.2
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf DiffuseConvolution
		#pragma target 3.0

		sampler2D _MainTex;
		sampler2D _AOMap;
		sampler2D _BumpMap;
		samplerCUBE _CubeMap;
		float4 _Tint;
		float _SpecIntensity;
		float _SpecWidth;

		struct Input {
			float2 uv_AOMap;
			float3 worldNormal;
			INTERNAL_DATA
		};

		void surf (Input IN, inout SurfaceOutput o) {
			half4 c = tex2D (_MainTex, IN.uv_MainTex);
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}

		inline fixed4 LightingDiffuseConvolution(SurfaceOutput s, fixed3 lightDir, fixed3 viewDir, fixed atten)
		{
			viewDir = normalize(viewDir);
			lightDir = normalize(lightDir);
			s.Normal = normalize(s.Normal);
			float NDotL = dot (s.Normal, lightDir);
			float3 halfVec = normalize (lightDir + viewDir);

			float spec = pow(dot(s.Normal, halfVec), s.Specular * 128) * s.Gloss;

			fixed4 c;
			c.rgb = ( s.Albedo * atten) + spec;
			c.a = 1.0f;
			return c;
		}

		ENDCG
	} 
	FallBack "Diffuse"
}
