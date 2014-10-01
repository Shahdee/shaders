Shader "Custom/Cloth" {
	Properties {
		_Tint("Tint", Color) = (1,1,1,1)
		_BumpMap ("bump map", 2D) = "white" {}
		_DetailBump ("detail bump", 2D) = "white" {}
		_DetailTex ("detail texture", 2D) = "white" {}
		_FresnelColor("fresnel color", Color) = (1,1,1,1)
		_FresnelPower("fresnel power", Range(0,12)) = 0.5
		_RimPower("rim power", Range(0,12)) = 0.5
		_SpecIntensity("_SpecIntensity", Range(0,1)) = 0.5
		_SpecWidth("_SpecWidth", Range(0,1)) = 0.5
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Velvet
		#pragma target 3.0

		float4 _Tint;
		sampler2D _BumpMap;
		sampler2D _DetailBump;
		sampler2D _DetailTex ;
		float4 _FresnelColor;
		float _FresnelPower;
		float _RimPower;
		float _SpecIntensity;
		float _SpecWidth;

		struct Input {
			float2 uv_BumpMap;
			float2 uv_DetailBump;
			float2 uv_DetailTex;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			half4 c = tex2D (_DetailTex, IN.uv_DetailTex);
			fixed3 normals = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap)).rgb;
			fixed3 detailNormals = UnpackNormal(tex2D(_DetailBump, IN.uv_DetailBump)).rgb;
			fixed3 finalNormals  = float3(normals.x + detailNormals.x,
										  normals.y + detailNormals.y,
										  normals.z + detailNormals.z);

			o.Normal = normalize(finalNormals);
			o.Specular = _SpecWidth;
			o.Gloss = _SpecIntensity;
			o.Albedo = c.rgb * _Tint;
			o.Alpha = c.a;
		}

		inline fixed4 LightingVelvet(SurfaceOutput s, float3 lightDir, float3 viewDir, fixed atten)
		{
			lightDir = normalize(lightDir);
			viewDir = normalize(viewDir);

			float3 halfVec = normalize(viewDir+lightDir);
			fixed NdotL = max(0, dot(s.Normal, lightDir));
			fixed NdotH = max(0, dot(s.Normal, halfVec));
			float spec = pow (NdotH, s.Specular*128.0)*s.Gloss;

			float HdotV = pow(1-max(0, dot(halfVec, viewDir)), _FresnelPower);
			float NdotE = pow(1-max(0, dot(s.Normal, viewDir)), _RimPower);
			float finalSpecMask = NdotE * HdotV;

			fixed4 c;
			c.rgb = (s.Albedo*NdotL*_LightColor0.rgb) + (spec*(finalSpecMask*_FresnelColor))*(atten*2);
			c.a = 1;
			return c;
		} 

		ENDCG
	} 
	FallBack "Diffuse"
}
