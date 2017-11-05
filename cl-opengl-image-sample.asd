
(in-package :cl-user)
(defpackage cl-opengl-image-sample-asd
  (:use :cl :asdf))
(in-package :cl-opengl-image-sample-asd)

(defsystem cl-opengl-image-sample
  :depends-on (:cl-opengl :cl-glut :cl-glu)
  :components (
    (:module "src"
			:around-compile
				(lambda (thunk)
          ; dev
          (declaim (optimize (speed 0) (debug 3) (safety 3)))
          ; release
          ; (declaim (optimize (speed 3) (debug 0) (safety 0)))
					(funcall thunk))
      :components (
        (:file "package")
        (:file "cl-opengl-image-sample")))))

