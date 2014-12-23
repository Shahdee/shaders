using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class ImageEffects : MonoBehaviour {

    public Shader m_Shader;
    [Range(0,1)]
    public float m_Grayscale = 0f;
    [Range(0,5)]
    public float m_DepthPower = 0f;
    Material m_Material;
    Material Material
    {
        get
        {
            if (m_Material==null)
            {
                m_Material = new Material(m_Shader);
                m_Material.hideFlags = HideFlags.HideAndDontSave;
            }
            return m_Material;
        }
    }

	
	void Start () {

        if (!SystemInfo.supportsImageEffects)
            enabled = false;

        if (!m_Shader && !m_Shader.isSupported)
            enabled = false;
	}

    void Update() 
    {
        Camera.main.depthTextureMode = DepthTextureMode.Depth;
        m_Grayscale = Mathf.Clamp01(m_Grayscale);
        m_DepthPower = Mathf.Clamp(m_DepthPower, 0f, 5f);
    }
	
	
	void OnRenderImage(RenderTexture source, RenderTexture dest)
    {
        if (m_Shader != null) 
        {
            Material.SetFloat("_DepthPower", m_DepthPower);
            Graphics.Blit(source, dest, Material);
        }
        else
            Graphics.Blit(source, dest, null);
    }

    void OnDisable()
    {
        if (Material != null)
            DestroyImmediate(Material);
    }
}
