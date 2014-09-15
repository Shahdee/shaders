Shader "Custom/SpecularNew" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Power("pow", Range(0,60)) =0.5
		_Tint("Tint", Color) = (1,1,1,1)
		_SpecularColor("Color", Color) = (1,1,1,1)
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		//#pragma surface surf Phong
		#pragma surface surf CustomBlinnPhong

		sampler2D _MainTex;
		float4 _Tint;
		float _Power;
		float4 _SpecularColor;

		struct Input {
			float2 uv_MainTex;
		};

		void surf (Input IN, inout SurfaceOutput o) {

			half4 c = tex2D (_MainTex, IN.uv_MainTex);
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}

		inline fixed4 LightingCustomBlinnPhong(SurfaceOutput s, fixed3 lightDir, half3 viewDir, fixed atten)
		{
			float3 halfVec = normalize(lightDir + viewDir);
			float diff = max(0, dot(s.Normal, lightDir));

			float nh = max(0, dot(s.Normal, halfVec));
			float spec = pow(nh, _Power) * _SpecularColor;

			fixed4 c;
			c.rgb = (s.Albedo * _LightColor0 * diff) + (_LightColor0.rgb * _SpecularColor.rgb * spec ) * atten * 2;
			c.a = s.Alpha;

			return c;
		}

		/*
		inline fixed4 LightingPhong(SurfaceOutput s, fixed3 lightDir, half3 viewDir, fixed atten)
		{
			float diff = dot(s.Normal, lightDir);
			float3 reflectionVec = normalize(2.0 * diff * s.Normal - lightDir);
			
			
			float spec = pow(max(0, dot(reflectionVec, viewDir)), _Power);
			float3 finalSpec = _SpecularColor.rgb * spec;

			fixed4 c;
			c.rgb = (s.Albedo * _LightColor0 * diff) + (_LightColor0.rgb*finalSpec);
			c.a = 1.0;

			return c;
		}*/

		ENDCG
	} 
	FallBack "Diffuse"
}
