using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;
using System.Runtime.InteropServices;
using System.Xml.Linq;
using UnityEngine.UI;
using System;

public class DragObject : MonoBehaviour {
    public float shakeDuration = 1.5f;

    private Vector3 _offset;
    private Vector3 _startPosition;
    private Material _material;
    private float _shakeTimeLeft = 0f;
    private float _shakeAmplitude = 0f;
    private int _propertyId;

    void Start() {
        _propertyId = Shader.PropertyToID("_Force");
        SpriteRenderer spriteRenderer = GetComponent<SpriteRenderer>();
        if (spriteRenderer != null) {
            _material = spriteRenderer.material;
        }
    }

    void OnMouseDown() {
        _startPosition = gameObject.transform.position;
        _offset = _startPosition - Camera.main.ScreenToWorldPoint(Input.mousePosition);
    }

    void OnMouseDrag() {
        transform.position = Camera.main.ScreenToWorldPoint(Input.mousePosition) + _offset;
    }

    void OnMouseUp() {
        _shakeTimeLeft = shakeDuration;
        float dx = (gameObject.transform.position.x - _startPosition.x);
        float dy = (gameObject.transform.position.y - _startPosition.y) * 0.25f;
        if (Mathf.Abs(dx) > Mathf.Abs(dy)) {
            _shakeAmplitude = dx;
        } else {
            _shakeAmplitude = dy;
        }
    }

    void Update() {
        if (_shakeTimeLeft > 0f) {
            if (_material != null) {
                float rate = (_shakeTimeLeft / shakeDuration);
                rate = rate * rate * rate;
                _material.SetFloat(_propertyId, rate * _shakeAmplitude);
            }
            _shakeTimeLeft -= Time.deltaTime;
        }
    }
}
