using UnityEngine;

public class Procedural : MonoBehaviour {

    public int m_Width = 512;
    public int m_Height = 512;

    Texture2D m_Texture;


    Material m_Material = null;
    Vector2 m_CenterPos = Vector3.zero;

	void Start () 
    {
        m_Material = transform.renderer.sharedMaterial;
        if (m_Material) 
        {
            m_CenterPos = new Vector2(0.5f, 0.5f);
            m_Texture = GenerateTexture();
            m_Material.SetTexture("_MainTex", m_Texture);
        }
	}

    Texture2D GenerateTexture() 
    {
        Texture2D texture = new Texture2D(m_Width, m_Height);
        Vector2 center = m_CenterPos * m_Width;
        for (int i = 0; i < m_Height; i++)
            for (int j = 0; j < m_Width; j++) 
            {
                Vector2 pos = new Vector2(i, j);
                float dist = Vector2.Distance(pos, center) / m_Width * 0.5f;
                dist = Mathf.Abs(1 - Mathf.Clamp(dist,0f,1f));
                dist = Mathf.Sin(dist*30)*dist;
                Color pxColor = new Color(dist, dist, dist, 1f);
                texture.SetPixel(i, j, pxColor);
            }
        texture.Apply();
        return texture;
    }
}
