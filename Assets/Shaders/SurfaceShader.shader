Shader "Custom/SurfaceShader" {
	Properties {
		_Red ("Red channel tex", 2D) = "white" {}
		_Green ("Green channel tex", 2D) = "white" {}
		_Blue ("Blue channel tex", 2D) = "white" {}
		_Alpha ("Alpha channel tex", 2D) = "white" {}
		_Blend("Blend channel tex", 2D) = "white" {}

		_ColA("Terr color A", Color) = (1,1,1,1)
		_ColB("Terr color B", Color) = (1,1,1,1)
		_Tint("Tint color", Color) = (1,1,1,1)
	
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf Lambert

		sampler2D _Red, _Green, _Blue, _Alpha, _Blend;
		float4 _Tint, _ColA, _ColB;

		struct Input {
			float2 uv_Red;
			float2 uv_Green;
			float2 uv_Blue;
			float2 uv_Alpha;
			float2 uv_Blend;
		};

		void surf (Input IN, inout SurfaceOutput o) {

			
			float4 blend = tex2D(_Blend, IN.uv_Blend);
			float4 red = tex2D(_Red, IN.uv_Red);
			float4 green = tex2D(_Green, IN.uv_Green);
			float4 blue = tex2D(_Blue, IN.uv_Blue);
			float4 alpha = tex2D(_Alpha, IN.uv_Alpha);

			float4 finalCol;
			finalCol = lerp (red,green,blend.g);
			finalCol = lerp(finalCol, blue, blend.b);
			finalCol = lerp(finalCol, alpha, blend.a);
			finalCol.a=1.0;

			float4 terrLayers = lerp(_ColA, _ColB, blend.r);
			finalCol *= terrLayers;
			finalCol = saturate(finalCol);

			o.Albedo = finalCol.rgb * _Tint.rgb;
			o.Alpha = finalCol.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
