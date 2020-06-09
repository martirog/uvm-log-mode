;; test of standard uvm report log mode

(defcustom stupid-uvm-log-mode-hook nil
  "Hook run after init of stupid uvm log mode"
  :group 'stupid-uvm-log-mode
  :type 'hook)

;; needs to bae a list as the simulator might insert non UVM lines
(setq urlm-fatal-key-list '("UVM_FATAL" "** Fatal:" "Fatal:"))
(setq urlm-error-key-list '("UVM_ERROR" "** Error:" "Error:"))
(setq urlm-critical-w-key-list '("UVM_CRITICAL_WARNING"))
(setq urlm-warning-key-list '("UVM_WARNING" "** Warning:" "Warning:"))
(setq urlm-info-key-list '("UVM_INFO" "** Info:" "Info:"))

;; make regexp
(setq urlm-fatal-regexp (regexp-opt urlm-fatal-key-list 'word))
(setq urlm-error-regexp (regexp-opt urlm-error-key-list 'word))
(setq urlm-critical-w-regexp (regexp-opt urlm-critical-w-key-list 'word))
(setq urlm-warning-regexp (regexp-opt urlm-warning-key-list 'word))
(setq urlm-info-regexp (regexp-opt urlm-info-key-list 'word))

;; define colors
(defface urlm-fatal-face '((t :foreground "red")) "Fatal keyword look" :group 'stupud-uvm-log-mode)
(defface urlm-error-face '((t :foreground "orange red")) "Error keyword look" :group 'stupud-uvm-log-mode)
(defface urlm-critical-warning-face '((t :foreground "gold")) "Critical Warning keyword look" :group 'stupud-uvm-log-mode)
(defface urlm-warning-face '((t :foreground "yellow")) "Warning keyword look" :group 'stupud-uvm-log-mode)
(defface urlm-info-face '((t :foreground "green")) "Info keyword look" :group 'stupud-uvm-log-mode)

;(face-spec-set 'urlm-fatal-face            '((t :foreground "red"))          'face-defface-spec)
;(face-spec-set 'urlm-error-face            '((t :foreground "light red"))    'face-defface-spec)
;(face-spec-set 'urlm-critical-warning-face '((t :foreground "yellow"))       'face-defface-spec)
;(face-spec-set 'urlm-warning-face          '((t :foreground "light yellow")) 'face-defface-spec)
;(face-spec-set 'urlm-info-face             '((t :foreground "green"))        'face-defface-spec)

;; combine regexp and face
(setq urlm-color-scheame
      `(
        (,urlm-fatal-regexp . 'urlm-fatal-face)
        (,urlm-error-regexp . 'urlm-error-face)
        (,urlm-critical-w-regexp . 'urlm-critical-warning-face)
        (,urlm-warning-regexp . 'urlm-warning-face)
        (,urlm-info-regexp . 'urlm-info-face)
        ))

(defun sulm-set-hide-verbosity ()
  (interactive)
  (add-to-invisibility-spec 'stupid-uvm-log-cw)
  (add-to-invisibility-spec 'stupid-uvm-log-w)
  (add-to-invisibility-spec 'stupid-uvm-log-i)
  (save-excursion
    (goto-char (point-min))
    (while (not (eobp))
      (message "%d" (point))
      (if (looking-at "\
\\(\\<UVM_CRITICAL_WARNING\\>\\)\\|\
\\(\\<UVM_WARNING\\>\\)\\|\
\\(\\<** Warning:\\>\\)\\|\
\\(\\<Warning:\\>\\)\\|\
\\(\\<UVM_INFO\\>\\)\\|\
\\(\\<** Info:\\>\\)\\|\
\\(\\<Info:\\>\\)") ; need to fix this as a concat of the key lists
          (cond
           ((match-end 1)
            (let ((po (point)))
              (message "%d" po)
              (forward-line 1)
              (put-text-property po (point) 'invisible 'stupid-uvm-log-cw)))
           ((match-end 2)
            (let ((po (point)))
              (message "%d" po)
              (forward-line 1)
              (put-text-property po (point) 'invisible 'stupid-uvm-log-w)))
           ((match-end 3)
            (let ((po (point)))
              (message "%d" po)
              (forward-line 1)
              (put-text-property po (point) 'invisible 'stupid-uvm-log-w)))
           ((match-end 4)
            (let ((po (point)))
              (message "%d" po)
              (forward-line 1)
              (put-text-property po (point) 'invisible 'stupid-uvm-log-w)))
           ((match-end 5)
            (let ((po (point)))
              (message "%d" po)
              (forward-line 1)
              (put-text-property po (point) 'invisible 'stupid-uvm-log-i)))
           ((match-end 6)
            (let ((po (point)))
              (message "%d" po)
              (forward-line 1)
              (put-text-property po (point) 'invisible 'stupid-uvm-log-i)))
           ((match-end 7)
            (let ((po (point)))
              (message "%d" po)
              (forward-line 1)
              (put-text-property po (point) 'invisible 'stupid-uvm-log-i)))
           (t (forward-line 1))) ; need to add non UVM log line hide here
        (forward-line 1)))))

(defun sulm-view-critical-warning ()
  (interactive)
  (remove-from-invisibility-spec 'stupid-uvm-log-cw))

(defun sulm-view-warning ()
  (interactive)
  (remove-from-invisibility-spec 'stupid-uvm-log-w))

(defun sulm-view-info ()
  (interactive)
  (remove-from-invisibility-spec 'stupid-uvm-log-i))

(define-derived-mode stupid-uvm-log-mode
  fundamental-mode "stupid-uvm-log"
  "Major mode for viewing UVM logs"
  (setq font-lock-defaults '(urlm-color-scheame))
  (sulm-set-hide-verbosity))
