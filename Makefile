HTDOCS = htdocs
SPRITES = sprites/*
WEBROOT = hhsw.de@ssh.strato.de:sites/proto/js13k2015
OPTIONS = \
	--recursive \
	--links \
	--update \
	--delete-after \
	--times \
	--compress

all: atlas live

live:
	rsync $(OPTIONS) \
		$(HTDOCS)/* \
		$(WEBROOT)

atlas: $(SPRITES)
	cd $(HTDOCS) && \
		mkatlas ../$(SPRITES) | \
		patchatlas index.html && \
		sed -e "s_data:image/png;base64,[/+a-zA-Z0-9=]*_data:image/png;base64,$$(base64 -w 0 atlas.png)_" \
			< index.html \
			> tmp.html && \
		mv tmp.html index.html && \
		rm atlas.png

check:
	@echo $$(SIZE=`zip -r htdocs.zip htdocs -x '*.swp' &>/dev/null && \
		stat --format '%s' htdocs.zip && \
		rm -f htdocs.zip`; echo "$$SIZE bytes"; \
		(( $$SIZE > 13312 )) && echo '> 13312 !!! TOO MUCH !!!' )
