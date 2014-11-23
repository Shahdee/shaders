using UnityEngine;
using System.Collections;

[RequireComponent(typeof(MeshFilter))]
public class MeshColor : MonoBehaviour {

    public void Start()
    {
        Mesh mesh = gameObject.GetComponent<MeshFilter>().mesh;
        Vector3[] vertices = mesh.vertices;
        Color[] colors = new Color[vertices.Length];
        int i = 0;
        while (i < vertices.Length) 
        {
            colors[i] = Color.Lerp(Color.red, Color.green, Random.value);
            i++;
        }
        mesh.colors = colors;
    }
}
