Shader "Custom/VertexColor" {
	
	Properties {
		_Tint("Tint", Color) = (1,1,1,1)
	}

	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert vertex:vert

		float4 _Tint;

		struct Input {
			float2 uv_MainTex;
			float4 vertColor;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			o.Albedo = IN.vertColor.rgb * _Tint.rgb;
		}

		void vert(inout appdata_full v, out Input o)
		{
			UNITY_INITIALIZE_OUTPUT(Input,o)
			o.vertColor = v.color;
		}

		ENDCG
	} 
	FallBack "Diffuse"
}
