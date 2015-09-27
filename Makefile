HTDOCS = htdocs
SPRITES = sprites/*
WEBROOT = hhsw.de@ssh.strato.de:sites/eugor
OPTIONS = \
	--recursive \
	--links \
	--update \
	--delete-after \
	--times \
	--compress

live:
	rsync $(OPTIONS) \
		$(HTDOCS)/* \
		$(WEBROOT)

atlas: $(SPRITES)
	cd $(HTDOCS) && \
		mkatlas ../$(SPRITES) | \
		patchatlas index.html

pack:
	zip -r htdocs.zip htdocs -x '*.swp'

size:
	@echo $$(SIZE=`zip -r htdocs.zip htdocs -x '*.swp' &>/dev/null && \
		stat --format '%s' htdocs.zip && \
		rm -f htdocs.zip`; echo "$$SIZE bytes"; \
		(( $$SIZE > 13312 )) && echo '> 13312 !!! TOO MUCH !!!' )
