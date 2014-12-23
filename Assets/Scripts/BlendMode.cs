using UnityEngine;
using System.Collections;

public class BlendMode : MonoBehaviour {

    public Shader m_Shader;
    public Texture m_Texture;
    Material m_Material;
    Material Material 
    {
        get 
        {
            if (m_Material == null) 
            {
                m_Material = new Material(m_Shader);
                m_Material.hideFlags = HideFlags.HideAndDontSave;
            }
            return m_Material;
        }
    }

    [Range(0,1)]
    public float m_Opacity = 1.0f;

	void Start () {

        if (!SystemInfo.supportsImageEffects)
            enabled = false;

        if (!m_Shader && !m_Shader.isSupported)
            enabled = false;
	}

    void OnRenderImage(RenderTexture source, RenderTexture destination) 
    {
        if (m_Shader != null)
        {
            Material.SetTexture("_BlendTex", m_Texture);
            Material.SetFloat("_Opacity", m_Opacity);
            Graphics.Blit(source, destination, Material);
        }
        else
            Graphics.Blit(source, destination);
    }
	
	// Update is called once per frame
	void Update () {

        m_Opacity = Mathf.Clamp(m_Opacity, 0, 1);
	}

    void OnDisable() 
    {
        if (Material != null)
            DestroyImmediate(Material);
    }
}
