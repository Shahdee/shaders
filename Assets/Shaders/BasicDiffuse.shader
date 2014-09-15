Shader "Custom/DiShahder" 
{
	Properties 
	{
		_RampTex("Ramp Texture", 2D) = "White" {}
		//_FirstTex("Texture", 2D) = "White" {}
		_EmissiveColor ("Emissive Color", Color) = (1,1,1,1)
		_AmbientColor ("Ambient Color", Range(0,10)) = 2
		_SliderVal ("This is a Slider", Range(0,10)) = 2.5
	}

	SubShader 
	{
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf BasicDiffuse

		sampler2D _RampTex;
		float4 _EmissiveColor;
		float4 _AmbientColor;
		float _SliderVal;

		struct Input {
			float2 uv_MainTex;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			float4 c = pow((_EmissiveColor + _AmbientColor), _SliderVal);
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}

		inline float4 LightingBasicDiffuse(SurfaceOutput s, fixed3 lightDir, half3 viewDir, fixed atten)
		{
			float difLight = dot(s.Normal, lightDir);
			float hLambert = difLight * 0.5 + 0.5;
			//float rimLight = dot(s.Normal, viewDir);
			//float3 ramp = tex2D(_RampTex, float2(hLambert, rimLight)).rgb;

			float4 col;
			col = float4(hLambert,hLambert,hLambert,1); //s.Albedo  * _LightColor0.rgb * (ramp);
			return col;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
