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

(require 'fzf)
(require 'posframe)

(defgroup fzf-posframe nil
  "Show fzf window via posframe."
  :group 'convenience
  :link '(url-link :tag "Github" "https://github.com/conao3/fzf-posframe.el"))

(provide 'fzf-posframe)

;;; fzf-posframe.el ends here
