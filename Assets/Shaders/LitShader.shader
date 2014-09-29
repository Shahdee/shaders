Shader "Custom/LitShader" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Tint("Tint", Color) = (1,1,1,1)
		_NormalMap("Normal map", 2D) = "bump" {}
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Unlit vertex:vert

		sampler2D _MainTex;
		sampler2D _NormalMap;
		float4 _Tint;

		struct Input {
			float2 uv_MainTex;
			float2 uv_NormalMap;
			float3 tan1;
			float3 tan2;
		};

		void vert(inout appdata_full v, out Input o)
		{
			UNITY_INITIALIZE_OUTPUT(Input,o);

			TANGENT_SPACE_ROTATION;

			o.tan1 = mul(rotation, UNITY_MATRIX_IT_MV[0].xyz);
			o.tan2 = mul(rotation, UNITY_MATRIX_IT_MV[1].xyz);
		}

		void surf (Input IN, inout SurfaceOutput o) {

			float3 normal = UnpackNormal(tex2D(_NormalMap, IN.uv_NormalMap));
			o.Normal = normal;

			float2 litSpUV;
			litSpUV.x = dot(IN.tan1, o.Normal); 
			litSpUV.y = dot(IN.tan2, o.Normal);

			half4 c = tex2D (_MainTex, litSpUV*0.5+0.5);
			o.Albedo = c.rgb*_Tint;
			o.Alpha = c.a;
		}

		inline fixed4 LightingUnlit(SurfaceOutput s, fixed3 lightDir, fixed atten)
		{
			fixed4 c = fixed4(1,1,1,1);
			c.rgb = c * s.Albedo;
			c.a = s.Alpha;
			return c;
		}

		ENDCG
	} 
	FallBack "Diffuse"
}
