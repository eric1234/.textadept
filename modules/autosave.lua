-- Auto-save all unsaved buffers when switching focus
events.connect(events.UNFOCUS, io.save_all_files)
events.connect(events.BUFFER_BEFORE_SWITCH, io.save_all_files)
events.connect(events.VIEW_BEFORE_SWITCH, io.save_all_files)
