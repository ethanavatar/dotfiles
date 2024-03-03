export def "mkv remux" [
	input_file: path,
    crf: int = 23
] {
    let $output_file = $input_file
        | path parse
        | $"($in.stem).mp4"

    print $"+ ffmpeg -i ($input_file) -c:v libx264 -preset slow -crf ($crf) -c:a aac -movflags +faststart ($output_file)\n"
    ffmpeg -i $input_file -c:v libx264 -preset slow -crf $crf -c:a aac -movflags +faststart $output_file
}
