;;; fzf-posframe.el --- Show fzf window via posframe  -*- lexical-binding: t; -*-

;; Copyright (C) 2020  Naoya Yamashita

;; Author: Naoya Yamashita <conao3@gmail.com>
;; Version: 0.0.1
;; Keywords: convenience
;; Package-Requires: ((emacs "26.1") (fzf "0.2") (posframe "0.8.5"))
;; URL: https://github.com/conao3/fzf-posframe.el

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; Show fzf window via posframe.


;;; Code:

(require 'term)
(require 'fzf)
(require 'posframe)

(defgroup fzf-posframe nil
  "Show fzf window via posframe."
  :group 'convenience
  :link '(url-link :tag "Github" "https://github.com/conao3/fzf-posframe.el"))

(defcustom fzf-posframe-style 'frame-center
  "The style of fzf-posframe."
  :group 'fzf-posframe
  :type 'symbol)

(defcustom fzf-posframe-font nil
  "The font used by fzf-posframe.
When nil, Using current frame's font as fallback."
  :group 'fzf-posframe
  :type '(choice (const :tag "inherit" nil)
                 string))

(defcustom fzf-posframe-width nil
  "The width of fzf-posframe."
  :group 'fzf-posframe
  :type '(choice (const :tag "default" nil)
                 number))

(defcustom fzf-posframe-height nil
  "The height of fzf-posframe."
  :group 'fzf-posframe
  :type '(choice (const :tag "default" nil)
                 number))

(defcustom fzf-posframe-min-width 30
  "The width of fzf-min-posframe."
  :group 'fzf-posframe
  :type '(choice (const :tag "non-width" nil)
                 number))

(defcustom fzf-posframe-min-height 20
  "The height of fzf-min-posframe."
  :group 'fzf-posframe
  :type '(choice (const :tag "non-width" nil)
                 number))

(defcustom fzf-posframe-border-width 1
  "The border width used by fzf-posframe.
When 0, no border is showed."
  :group 'fzf-posframe
  :type '(choice (const :tag "non-width" nil)
                 number))

(defcustom fzf-posframe-parameters nil
  "The frame parameters used by fzf-posframe."
  :group 'fzf-posframe
  :type '(choice (const :tag "no-parameters" nil)
                 number))

(defface fzf-posframe
  '((t (:inherit default)))
  "Face used by the fzf-posframe."
  :group 'fzf-posframe)

(defface fzf-posframe-border
  '((t (:inherit default :background "gray50")))
  "Face used by the fzf-posframe's border."
  :group 'fzf-posframe)

(defvar fzf-posframe-buffer " *fzf*"
  "The posframe-buffer used by fzf-posframe.")

(defvar fzf-posframe--display-p nil
  "The status of `fzf-posframe--display'.")

;;; Functions

(defun fzf-posframe--display (buf &optional poshandler)
  "Show BUF using posframe via POSHANDLER."
  (declare (indent 1))
  (if (not (posframe-workable-p))
      (warn "fzf-posframe is busy now!")
    (setq fzf-posframe--display-p t)
    (posframe-show
     buf
     :font fzf-posframe-font
     :position (point)
     :poshandler poshandler
     :background-color (face-attribute 'fzf-posframe :background nil t)
     :foreground-color (face-attribute 'fzf-posframe :foreground nil t)
     :height fzf-posframe-height
     :width fzf-posframe-width
     :min-height (or fzf-posframe-min-height 1)
     :min-width (or fzf-posframe-min-width 10)
     :internal-border-width fzf-posframe-border-width
     :internal-border-color (face-attribute 'fzf-posframe-border :background nil t)
     :override-parameters fzf-posframe-parameters)))

(defun fzf-posframe-display (buf)
  "Display BUF via `posframe' by `fzf-posframe-style'."
  (let ((func (intern (format "fzf-posframe-display-at-%s" fzf-posframe-style))))
    (if (functionp func)
        (funcall func buf)
      (funcall (intern (format "fzf-posframe-display-at-%s" "point")) buf))))

(eval
 `(progn
    ,@(mapcar
       (lambda (elm)
         `(defun ,(intern (format "fzf-posframe-display-at-%s" (car elm))) (buf)
            ,(format "Display BUF via `posframe' at %s" (car elm))
            (fzf-posframe--display buf #',(intern (format "posframe-poshandler-%s" (cdr elm))))))
       '((window-center      . window-center)
         (frame-center       . frame-center)
         (window-bottom-left . window-bottom-left-corner)
         (frame-bottom-left  . frame-bottom-left-corner)
         (point              . point-bottom-left-corner)))))

(defun fzf-posframe-display-at-frame-bottom-window-center (buf)
  "Display BUF via `posframe' at frame-bottom-window-center."
  (fzf-posframe--display buf
    (lambda (info)
      (cons (car (posframe-poshandler-window-center info))
            (cdr (posframe-poshandler-frame-bottom-left-corner info))))))

(defun fzf-posframe-cleanup ()
  "Cleanup fzf-posframe."
  (when (fzf-posframe-workable-p)
    (posframe-hide fzf-posframe-buffer)
    (setq fzf-posframe--display-p nil)))

(defun fzf-posframe-workable-p ()
  "Test fzf-posframe workable status."
  (and (>= emacs-major-version 26)
       (not (or noninteractive
                (not (display-graphic-p))))))

(defun fzf-posframe-window ()
  "Return the posframe window displaying `fzf-posframe-buffer'."
  (frame-selected-window
   (buffer-local-value 'posframe--frame (get-buffer fzf-posframe-buffer))))

;;; Advice

(declare-function turn-off-evil-mode "evil")

(defvar fzf-posframe-advice-alist
  '((fzf/start . fzf-posframe-advice--fzf/start)))

(defun fzf-posframe-advice--fzf/start (_fn &rest args)
  "Advice function for FN with ARGS."
  (message "fzf-posframe-advice--fzf/start")
  (let ((directory (pop args))
        (cmd-stream (pop args)))
    (window-configuration-to-register fzf/window-register)
    (advice-add 'term-handle-exit :after #'fzf/after-term-handle-exit)
    (let ((window-height
           (let ((min-height (min fzf/window-height (/ (window-height) 2))))
             (if fzf/position-bottom (- min-height) min-height)))
          (sh-cmd (if cmd-stream
                      (concat cmd-stream " | " fzf/executable " " fzf/args)
                    (concat fzf/executable " " fzf/args)))
          (term-exec-hook nil)
          (default-directory directory))
      (split-window-vertically window-height)
      (with-current-buffer (make-term "fzf" "sh" nil "-c" sh-cmd)
        (fzf-posframe-display (current-buffer))

        ;; disable various settings known to cause artifacts, see #1 for more details
        (linum-mode 0)
        (visual-line-mode 0)
        (and (fboundp #'turn-off-evil-mode) (turn-off-evil-mode))
        (setq-local scroll-margin 0)
        (setq-local scroll-conservatively 0)
        (setq-local show-trailing-whitespace nil)
        (setq-local display-line-numbers nil)

        (term-char-mode)
        (setq-local mode-line-format (format "   FZF  %s" directory))))))

(defun fzf-posframe--setup ()
  "Setup `fzf-posframe'."
  (pcase-dolist (`(,sym . ,fn) fzf-posframe-advice-alist)
    (advice-add sym :around fn)))

(defun fzf-posframe--teardown ()
  "Functions used as advice when redisplaying buffer."
  (pcase-dolist (`(,sym . ,fn) fzf-posframe-advice-alist)
    (advice-remove sym fn)))

;;;###autoload
(define-minor-mode fzf-posframe-mode
  "Enable fzf-posframe-mode."
  :global t
  :lighter " fzf-pf"
  (if fzf-posframe-mode
      (fzf-posframe--setup)
    (fzf-posframe--teardown)))

(provide 'fzf-posframe)

;;; fzf-posframe.el ends here
