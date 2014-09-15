Shader "Custom/SpecularSet" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Tint("Tint", Color) = (1,1,1,1)
		_SpecularColor("Spec color", Color) = (1,1,1,1)
		_RoTex("Rough tex", 2D) = "white" {}
		_RoRange("Rough", Range(0,1)) = 0.5
		_SpecPower("Spec power", Range(0,30)) = 2
		_Fresnel ("Fr", Range(0,1.0)) = 0.05

	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf MetallicSoft

		sampler2D _MainTex;
		sampler2D _RoTex;
		float4 _Tint;
		float4 _SpecularColor;
		float _RoRange;
		float _SpecPower;
		float _Fresnel;

		struct Input {
			float2 uv_MainTex;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			half4 c = tex2D (_MainTex, IN.uv_MainTex);
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}

		inline fixed4 LightingMetallicSoft(SurfaceOutput s, fixed3 lightDir, fixed3 viewDir, float atten)
		{
			float3 halfVec = normalize(lightDir + viewDir);
			float NDotL = saturate(dot(s.Normal, normalize(lightDir)));
			float NDotH_Raw = dot(s.Normal, halfVec);
			float NDotH = saturate(dot(s.Normal, halfVec));
			float NDotV = saturate(dot(s.Normal, normalize(viewDir)));
			float VDotH = saturate(dot(halfVec, normalize(viewDir)));
			
			float geo = NDotH * 2;
			float3 g1 = (geo * NDotV)/ NDotH; 
			float3 g2 = (geo * NDotL)/ NDotH; 
			float  g3 = min (1.0, min(g1,g2));

			float roughness = tex2D(_RoTex, float2(NDotH_Raw*0.5 + 0.5, _RoRange)).r;
			
			float fresnel = pow (1.0 - VDotH, 5.0);
			fresnel *= (1.0 - _Fresnel);
			fresnel += _Fresnel;

			float3 spec = fresnel * g3 * roughness * roughness;
			spec = spec * _SpecPower;
			
			fixed4 c;
			c.rgb = (s.Albedo * _LightColor0.rgb * NDotL) + (spec * _SpecularColor.rgb) * atten*2;
			c.a = s.Alpha;
			return c;
		}

		ENDCG
	} 
	FallBack "Diffuse"
}
