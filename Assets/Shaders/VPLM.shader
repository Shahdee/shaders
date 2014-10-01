Shader "Custom/VPLM" {
	Properties {
		_Tint("Tint", Color) = (1,1,1,1)
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_SpecularColor("Specular color", Color) = (1,1,1,1)
		_SpecPower("Spec power", Range(0, 30)) = 0.1
		_DiffusePower(" Diff power ", Range(0,10)) = 0.1
		_FalloffPower(" Fall power ", Range(0,10)) = 0.1
		_ReflAmount("Ref amount", Range(0, 1)) = 0.1
		_ReflPower("Ref power", Range(0, 3)) = 0.1
		_ReflCube("Ref cube", CUBE) = ""{}
		_BRDF("BRDF",2D) = "white" {}
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf CarPaint

		sampler2D _MainTex;
		sampler2D _BRDF;
		samplerCUBE _ReflCube;
		float4 _Tint;
		float4 _SpecularColor;
		float _SpecPower;
		float _DiffusePower;
		float _FalloffPower;
		float _ReflAmount;
		float _ReflPower;


		struct Input {
			float2 uv_MainTex;
			float3 worldRefl;
			float3 viewDir;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			half4 c = tex2D (_MainTex, IN.uv_MainTex);
			
			fixed falloff = saturate(1-dot(normalize(IN.viewDir), o.Normal));
			falloff = pow(falloff, _FalloffPower);

			o.Albedo = c.rgb * _Tint;
			o.Emission = pow((texCUBE(_ReflCube, IN.worldRefl).rgb * falloff), _ReflPower) * _ReflAmount;
			o.Specular = c.r;
			o.Gloss = 1.0;
			o.Alpha = c.a;
		}

		inline fixed4 LightingCarPaint(SurfaceOutput s, fixed3 lightDir, half3 viewDir, fixed atten)
		{
			half3 h = normalize(lightDir + viewDir);
			fixed diff = max(0, dot(s.Normal, lightDir));
			
			float ahdn = 1-dot(h, normalize(s.Normal));
			ahdn = pow(clamp(ahdn, 0.0, 1.0), _DiffusePower);
			half4 brdf = tex2D(_BRDF, float2(diff, 1-ahdn));

			float nh = max (0, dot (s.Normal, h));
			float spec = pow (nh, s.Specular * _SpecPower) * s.Gloss;

			fixed4 c;
			c.rgb = (s.Albedo * _LightColor0.rgb * brdf.rgb + _LightColor0.rgb * _SpecularColor.rgb * spec ) * (atten*2);
			c.a = s.Alpha + _LightColor0.a * _SpecularColor.a * spec * atten;
			return c;
		}

		ENDCG
	} 
	FallBack "Diffuse"
}
