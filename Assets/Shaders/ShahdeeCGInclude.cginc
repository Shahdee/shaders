#ifndef SHAHDEE_CG_INCLUDE
#define SHAHDEE_CG_INCLUDE

fixed4 _MyColor;

inline fixed4 LightingCustomLambert(SurfaceOutput s, fixed3 lightDir, fixed atten)
{
	fixed diff = max(0, dot(s.Normal, lightDir));
	
	#ifdef HalfLambert
	diff = (diff + 0.5)*0.5;
	#endif

	fixed4 c;
	c.rgb = s.Albedo * _LightColor0.rgb * ((diff*_MyColor.rgb)*atten*2);
	c.a = s.Alpha;
	return c;
}

#endif


