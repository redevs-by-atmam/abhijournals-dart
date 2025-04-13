import 'package:dart_main_website/config/layout.html.dart';
import 'package:dart_main_website/models/article.dart';
import 'package:dart_main_website/models/issue.dart';
import 'package:dart_main_website/models/journal.dart';

String articlePage(
    ArticleModel article, JournalModel journal, IssueModel issue) {
  final authors = article.authors.map((author) => author.name).join(', ');
  final authorMetaTags = article.authors
      .map((author) =>
          '  <meta name="citation_author" content="${author.name}">')
      .join('\n');
  final keywords = article.keywords.map((keyword) => keyword).join(', ');
  final formattedDate =
      "${article.createdAt.year}/${article.createdAt.month}/${article.createdAt.day}";
  return '''
${getHeaderHtml(journal, addedHeadTags: '''
  <meta name="citation_title" content="${article.title}">
$authorMetaTags
  <meta name="citation_publication_date" content="$formattedDate">
  <meta name="citation_journal_title" content="${journal.title}">
  <meta name="citation_volume" content="${article.volumeId}">
  <meta name="citation_issue" content="${article.issueId}">
  <meta name="citation_firstpage" content="${article.startPage}">
  <meta name="citation_lastpage" content="${article.endPage}">
  <meta name="citation_pdf_url" content="${article.pdf}">
  <meta name="citation_keywords" content="$keywords">
  <meta name="citation_language" content="en">
  <meta name="citation_abstract" content="${article.abstractString}">
 <script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "ScholarlyArticle",
  "headline": "${article.title}",
  "author": [
    ${article.authors.map((author) => '{ "@type": "Person", "name": "${author.name}" }').join(',\n    ')}
  ],
  "datePublished": "$formattedDate",
  "isPartOf": {
    "@type": "PublicationIssue",
    "issueNumber": "${issue.issueNumber}",
    "isPartOf": {
      "@type": "PublicationVolume",
      "volumeNumber": "${issue.volumeNumber}",
      "isPartOf": {
        "@type": "Periodical",
        "name": "${journal.title}"
      }
    }
  },
  "pagination": "${article.startPage}-${article.endPage}",
  "inLanguage": "en",
  "keywords": [
    "${article.keywords.map((keyword) => keyword).join('", "')}"
  ],
  "description": "${article.abstractString}",
  "url": "https://abhijournals.com/${journal.domain}/articles/${article.id}",
  "sameAs": "${article.pdf}"
}
</script>


''')}


<div class="container-fluid mt-5 mb-3">
  <div class="container">
    <div class="row">
      <div class="col-12">
        <div class="bg-white border p-4">
          <!-- Article Header -->
          <div class="article-header mb-4">
            <h2 class="article-title">${article.title}</h2>
            <div class="article-meta mt-3">
              <div class="d-flex flex-column flex-md-row justify-content-between align-items-start">
                <div>
                  <p class="text-muted mb-2">
                    <strong>Authors:</strong> $authors
                  </p>
                  
                  <p class="text-muted">
                    <strong>Published:</strong> ${article.createdAt}
                  </p>
                </div>
                <div class="mt-3 mt-md-0 ms-md-4">
                  <a href="${article.pdf}" class="btn btn-primary" target="_blank" rel="noopener noreferrer">
                    <i class="fas fa-file-pdf mr-2"></i>Download PDF
                  </a>
                </div>
              </div>
            </div>
          </div>

          <!-- Abstract -->
          <div class="article-abstract mb-4">
            <h4>Abstract</h4>
            <p class="text-justify">${article.abstractString}</p>
          </div>

          <!-- Keywords -->
          <div class="article-keywords mb-4">
            <h4>Keywords</h4>
            <p>$keywords</p>
          </div>

          <!-- References -->
          <div class="article-references mb-4">
            <h4>References</h4>
            <ol>
              ${article.references.map((reference) => '<li style="list-style-type: none;">$reference</li>').join()}
            </ol>
          </div>

          <!-- Download Section -->
          <div class="article-download mt-4">
            <a href="${article.pdf}" class="btn btn-primary" target="_blank" rel="noopener noreferrer">
              <i class="fas fa-file-pdf mr-2"></i>Download PDF
            </a>
          </div>

          <!-- Citation -->
          <div class="article-citation mt-4">
            <h4>How to Cite</h4>
            <div class="bg-light p-3">
              <p class="mb-0">
                $authors,
                (${article.createdAt}). ${article.title}. 
                ${journal.title}, 
                Volume ${article.volumeId}, Issue ${issue.issueNumber}.
              </p>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

${getFooterHtml(journal)}

''';
}
