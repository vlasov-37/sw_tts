$(function(){
            var generate_url = 'tts/generate/',
                get_file_url = 'tts/get_file',
                generate_button = $('#generate_button'),
                download_button = $('#download_button'),
                play_button = $("#play_button"),
                audio_block = $("#audio_block");
            var last_value = '';
            $('#id_text').keyup(function(){
                if ($(this).val() != last_value){
                    download_button.attr('disabled', 'disabled');
                    play_button.attr('disabled', 'disabled');
                }
                last_value = $(this).val();
                generate_button.prop('disabled', this.value == "" ? true : false);
            });

            audio_block.on('ended', function(){
                play_button.children('i').removeClass('fa-pause').addClass('fa-play');
            });
            play_button.click(function(){
                var ap = audio_block[0];
                if (!ap.paused){
                    ap.pause();
                    play_button.children('i').removeClass('fa-pause').addClass('fa-play');
                } else {
                    ap.play();
                    play_button.children('i').removeClass('fa-play').addClass('fa-pause');
                }
            });

            generate_button.click(function(){
                var text = $('#id_text').val();
                var csrf_token = $('[name=csrfmiddlewaretoken]').val();
                var response = $.post(generate_url, {
                    'text':text,
                    'csrfmiddlewaretoken':csrf_token,
                },function(data){
                    download_button.removeAttr('disabled').attr('href',get_file_url + '?uuid=' + data['uuid']);
                    play_button.removeAttr('disabled').attr('data-file-uuid', data['uuid']);
                    file_url = get_file_url + '?uuid=' + data['uuid'];
                    audio_block.attr('src',file_url)
                });
            })
        })