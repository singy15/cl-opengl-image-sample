
(in-package :cl-opengl-image-sample)

(defparameter *width* 200)
(defparameter *height* 200)

;; Variables.
(defparameter *tex* nil)

;; Load raw image.
(defun load-rgba-texture (path width height)
  (let ((texture (cffi:foreign-alloc '%gl:ubyte :count (* width height 4)))
        (image (alexandria:read-file-into-byte-vector path)))
      (loop for i from 0 to (1- (length image)) do
            (setf (cffi:mem-aref texture '%gl:ubyte i) (aref image i)))
      texture))

(defclass main-window (glut:window) 
  ()
	(:default-initargs 
    :title "cl-opengl-image-sample" 
    :mode '(:double :rgb :depth :stencil) 
    :width *width* 
    :height *height*))

(defmethod glut:idle ((window main-window))
  (glut:post-redisplay))

(defmethod glut:reshape ((w main-window) width height)
  (gl:viewport 0 0 width height)
  (gl:load-identity)
  (glu:ortho-2d 0.0 *width* *height* 0.0))

(defmethod glut:display ((window main-window))
  (gl:shade-model :flat)
  (gl:normal 0 0 1)
  (gl:clear-stencil 0)
  (gl:clear :color-buffer-bit :stencil-buffer-bit)

  ;; Draw texture.
  (gl:raster-pos 0 0)
  (gl:enable :texture-2d)
  (gl:enable :blend)
  (gl:blend-func :src-alpha :one-minus-src-alpha)
  (let ((x 100.0)
        (y 100.0)
        (size (/ 32.0 2.0))) 
    (gl:with-primitive :quads
    (gl:tex-coord 0 0)
    (gl:vertex (- x size) (- y size) 0)
    (gl:tex-coord 1 0)
    (gl:vertex (+ x size) (- y size) 0)
    (gl:tex-coord 1 1)
    (gl:vertex (+ x size) (+ y size) 0)
    (gl:tex-coord 0 1)
    (gl:vertex (- x size) (+ y size) 0)))
  (gl:disable :blend)
  (gl:disable :texture-2d)

  (glut:swap-buffers))

(defmethod glut:display-window :before ((window main-window))
  ;; Load texture.
  (gl:pixel-store :unpack-alignment 1)
  (setf *tex* (car (gl:gen-textures 1)))
  (gl:bind-texture :texture-2d *tex*)
  (gl:tex-parameter :texture-2d :texture-min-filter :nearest)
  (gl:tex-parameter :texture-2d :texture-mag-filter :nearest)
  (gl:tex-image-2d :texture-2d 0 :rgba 32 32 0 :rgba :unsigned-byte (load-rgba-texture "./resource/particle.raw" 32 32)))

(defmethod glut:close ((w main-window)))

(defun main ()
  (glut:display-window (make-instance 'main-window)))

(in-package :cl-user)

