Shader "Custom/VertexAnim" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_TintAmount("Tint amount", Range(0,1)) = 0.5
		_ColorA("Color A", Color) = (1,1,1,1)
		_ColorB("Color B", Color) = (1,1,1,1)
		_Speed("Speed", Range(0.1, 80)) = 0.5
		_Frequency("Frequency", Range(0,5)) = 0.5
		_Amp("Amp", Range(-1,1)) = 0.5
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert vertex:vert

		sampler2D _MainTex;
		float _TintAmount;
		float4 _ColorA;
		float4 _ColorB;
		float _Speed;
		float _Frequency;
		float _Amp;

		struct Input {
			float2 uv_MainTex;
			float3 vertColor;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			half4 c = tex2D (_MainTex, IN.uv_MainTex);
			float3 tint = lerp(_ColorA,_ColorB,IN.vertColor).rgb;
			o.Albedo = c.rgb * (tint*_TintAmount) ;
			o.Alpha = c.a;
		}

		void vert(inout appdata_full v, out Input o)
		{
			UNITY_INITIALIZE_OUTPUT(Input, o);
			float time = _Time * _Speed;
			float waveVal = sin(time + v.vertex.x * _Frequency)*_Amp;
			v.vertex.xyz = float3(v.vertex.x, v.vertex.y + waveVal, v.vertex.z);
			v.normal = normalize(float3(v.normal.x + waveVal, v.normal.y, v.normal.z));
			o.vertColor = float3(waveVal,waveVal,waveVal);
		}

		ENDCG
	} 
	FallBack "Diffuse"
}
