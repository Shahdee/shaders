Shader "Custom/8OptimizeShader" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Blend("Blend" , 2D) = "white" {}
		_Normal("Normal map", 2D) = "bump" {}
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf SimpleLambert exclude_path:prepass noforwardadd

		sampler2D _MainTex;
		sampler2D _Blend;
		sampler2D _Normal;

		struct Input {
			half2 uv_MainTex;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
			fixed4 c2 = tex2D(_Blend, IN.uv_MainTex);

			c = lerp(c, c2, c2.r);

			o.Albedo = c.rgb;
			o.Alpha = c.a;
			o.Normal = UnpackNormal(tex2D(_Normal, IN.uv_MainTex));
		}

		inline float4 LightingSimpleLambert(SurfaceOutput s, fixed3 lightDir, fixed atten)
		{
			fixed diff = max(0, dot(s.Normal, lightDir));

			fixed4 c;
			c.rgb = s.Albedo * _LightColor0.rgb * (diff*atten*2);
			c.a = s.Alpha;
			return c;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
