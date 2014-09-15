Shader "Custom/SpecularTexture" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Tint("Tint", Color) = (1,1,1,1)
		_Power("Power", Range(0.1, 120 )) = 3
		_Mask("Mask", 2D )= "white" {}
		_Color("Color", Color) = (1,1,1,1)
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf CustomPhong

		sampler2D _MainTex;
		sampler2D _Mask;
		float4 _Tint;
		float4 _Color;
		float _Power;

		struct SurfaceCustomOutput
		{
			fixed3 Albedo;
			fixed3 Normal;
			fixed3 Emission;
			fixed3 SpecularColor;
			half Specular;
			fixed Gloss;
			fixed Alpha;
		};

		struct Input {
			float2 uv_MainTex;
			float2 uv_Mask;
		};

		void surf (Input IN, inout SurfaceCustomOutput o) 
		{
			half4 c = tex2D(_MainTex, IN.uv_MainTex)*_Tint;
			float4 specMask = tex2D(_Mask, IN.uv_Mask)*_Color; 

			o.Albedo = c.rgb;
			o.Specular = specMask.r;
			o.SpecularColor = specMask.rgb;
			o.Alpha = c.a;
		}

		inline fixed4 LightingCustomPhong(SurfaceCustomOutput s, fixed3 lightDir, fixed3 viewDir, float atten)
		{
			float diff = dot(s.Normal, lightDir);
			float reflectionVec = normalize(2*s.Normal*diff-lightDir);

			float spec = pow(max(0.0, dot(reflectionVec, viewDir)), _Power)*s.Specular;
			float3 finalSpec = s.SpecularColor * spec * _Color.rgb;

			fixed4 c;
			c.rgb = (s.Albedo * _LightColor0.rgb * diff) + (_LightColor0.rgb * finalSpec);
			c.a = s.Alpha;

			return c;
		}

		ENDCG
	} 
	FallBack "Diffuse"
}
