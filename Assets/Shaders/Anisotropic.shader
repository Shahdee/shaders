Shader "Custom/Anisotropic" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Tint("Tint", Color) = (1,1,1,1)
		_Specular("Specular", Range(0,1)) = 0.5
		_SpecularPower("Specular power", Range(0,1)) = 0.5
		_SpecularColor("Spec color",Color) = (1,1,1,1)
		_AnisotropDir("Aniso dir", 2D) = "white" {}
		_AnisoOffset("Aniso offset", Range(-1,1)) = -0.2


	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Anisotrop
		#pragma target 3.0

		sampler2D _MainTex;
		float4 _Tint;
		float _Specular;
		float _SpecularPower;
		float4 _SpecularColor;
		sampler2D _AnisotropDir;
		float _AnisoOffset;

		struct Input {
			float2 uv_MainTex;
			float2 uv_AnisotropDir;
		};

		struct SurfaceAnisoOutput
		{
			fixed3 AnisoDirection;
			fixed3 Albedo;
			fixed3 Normal;
			fixed3 Emission;
			half Specular;
			fixed Gloss;
			fixed Alpha;
		};

		void surf (Input IN, inout SurfaceAnisoOutput o) {
			
			half4 c = tex2D(_MainTex, IN.uv_MainTex) * _Tint;
			float3 anisoTex = UnpackNormal(tex2D(_AnisotropDir, IN.uv_AnisotropDir));

			o.AnisoDirection = anisoTex;
			o.Specular = _Specular;
			o.Gloss = _SpecularPower;
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}

		inline fixed4 LightingAnisotrop(SurfaceAnisoOutput s, float3 lightDir, float3 viewDir, float atten)
		{
			float3 halfVec = normalize(normalize(lightDir)+ normalize(viewDir));
			float NDotL = saturate(dot(s.Normal, lightDir));

			fixed HDotA = dot(normalize(s.Normal + s.AnisoDirection), halfVec);
			float aniso = max( 0, sin( radians((HDotA + _AnisoOffset)*180) ) );
			float spec = saturate(pow(aniso, s.Gloss*128)*s.Specular);
			
			fixed4 c;
			c.rgb = ((s.Albedo * _LightColor0.rgb * NDotL) + (spec * _SpecularColor.rgb * _LightColor0.rgb)) * (atten*2);
			c.a = 1.0;
			return c;
		}

		ENDCG
	} 
	FallBack "Diffuse"
}
