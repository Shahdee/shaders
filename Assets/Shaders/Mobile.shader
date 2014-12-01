Shader "Custom/Mobile" {
	Properties {
		_Diffuse ("Base (RGB)", 2D) = "white" {}
		_Normal("Normal (RGB)", 2D) = "bump" {}
		_SpecInt("Spec int", Range(0.01,1)) = 0.5
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf MobileBP exclude_path:prepass nolightmap noforwardadd halfasview

		sampler2D _Diffuse;
		sampler2D _Normal;
		fixed _SpecInt;

		struct Input {
			float2 uv_Diffuse;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			fixed4 c = tex2D (_Diffuse, IN.uv_Diffuse);
			o.Albedo = c.rgb;
			o.Gloss = c.a;
			o.Alpha = 0.0;
			o.Specular = _SpecInt;
			o.Normal = UnpackNormal(tex2D(_Normal, IN.uv_Diffuse));
		}

		inline fixed4 LightingMobileBP(SurfaceOutput s, fixed3 lightDir, fixed3 halfDir, fixed atten)
		{
			fixed diff = max(0, dot(s.Normal, lightDir));
			fixed nh = max(0, dot(s.Normal, halfDir));
			fixed spec = pow(nh, s.Specular*128)*s.Gloss;

			fixed4 c;
			c.rgb = (s.Albedo *_LightColor0.rgb * diff + _LightColor0.rgb * spec) * (atten*2);
			c.a = 0.0;
			return c;
		}

		ENDCG
	} 
	FallBack "Diffuse"
}
