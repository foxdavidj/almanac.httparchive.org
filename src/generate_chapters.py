import os
import re
import mistune
import yaml

renderer = mistune.Renderer()
markdown = mistune.Markdown(renderer=renderer)

def generate_chapters():
    for language_dir in os.scandir('content'):
        language = language_dir.name

        for year_dir in os.scandir(language_dir.path):
            year = year_dir.name

            for chapter_file in os.scandir(year_dir.path):
                chapter = re.sub('.md$', '', chapter_file.name)

                (metadata, body) = parse_file(chapter_file)

                write_template(language, year, chapter, metadata, body)


def parse_file(chapter_file):
    with open(chapter_file, 'r') as f:
        content = f.read()

    pattern = r'^\s*(?:-{3})(.*?)(?:-{3})\s*(.+)$'
    (metadata_text, body_text) = re.findall(pattern, content, re.S | re.M)[0]

    metadata = yaml.load(metadata_text)
    body = markdown(body_text)

    return (metadata, body)


def write_template(language, year, chapter, metadata, body):
    template_path = 'templates/%s/%s/chapter.html' % (language, year)

    with open(template_path, 'r') as template_file:
        template = template_file.read()

    path = 'templates/%s/%s/chapters/%s.html' % (language, year, chapter)

    with open(path, 'w') as file_to_write:
        file_to_write.write(template.format(
            body=body, title=metadata['title'], description=metadata['description']))


generate_chapters()
