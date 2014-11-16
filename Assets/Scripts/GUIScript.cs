using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class GUIScript : MonoBehaviour {

    public int queueVal = 2000;

    void Update() 
    {
        Material currMat = transform.renderer.sharedMaterial;
        if (currMat)
        {
            currMat.renderQueue = queueVal;
        }
        else 
        {
            Debug.Log("no material");
        }
    }

}
