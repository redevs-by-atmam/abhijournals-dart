import 'package:dart_main_website/models/journal.dart';

const String headerHtml = '';


String getHeaderHtml(JournalModel journal) {
    return '''
<!DOCTYPE html>
<html lang="en">


<head>
    <base href="/">
    <title> ${journal.title} (${journal.domain.toUpperCase()}) | Abhi International Journals </title> 
    <meta charset="utf-8">

    <meta content="width=device-width, initial-scale=1.0" name="viewport">
    <meta name="robots" content="index, follow">

    <meta name="description" content="Abhi International Journals is a distinguished group of peer-reviewed academic journals dedicated to fostering global knowledge exchange and innovation across diverse domains of research and application. With a commitment to excellence, our journals provide a platform for researchers, academicians, and industry professionals to publish high-quality, original, and impactful research. Covering a wide spectrum of disciplines, including artificial intelligence, medical sciences, engineering, economics, management, and more, Abhi International Journals aims to bridge the gap between theoretical advancements and real-world applications.">
    <meta name="keywords" content="Abhi International Journals, peer-reviewed journals, global knowledge exchange, innovation, research, application, interdisciplinary collaboration, cutting-edge research, open access, scholarly discourse, trusted resource, global research community, AIJ, Abhi, International Journal">
    <link rel="sitemap" type="application/xml" title="Sitemap" href='sitemap_xml'>
    <link rel="robots" type="application/txt" title="Robots" href='robots_txt'>

    <!-- Favicon -->
    <link href="img/logo.png" rel="icon">
    <link href="img/logo.png" rel="apple-touch-icon">

    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.0/css/all.min.css" rel="stylesheet">

    <!-- Libraries Stylesheet -->
    <link href="lib/owlcarousel/assets/owl.carousel.min.css" rel="stylesheet">

    <!-- Customized Bootstrap Stylesheet -->
    <link href="css/style.css" rel="stylesheet">

</head>

<body>
    <!-- Topbar Start -->
    <div class="topbar d-none d-lg-block">
        <div class="row align-items-center bg-dark px-lg-5">
            <div class="col-lg-9">
                <nav class="navbar navbar-expand-sm bg-dark p-0">
                    <ul class="navbar-nav ml-n2">
                        <li class="nav-item border-right border-secondary">
                            <a class="nav-link text-body small" href="#" id="current_date">Loading date...</a>
                        </li>
                        <li class="nav-item border-right border-secondary">
                            <a class="nav-link text-body small"
                                href="#">Contact</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link text-body small" href="https://admin.abhijournals.com/"

                                target="_blank">Login</a>
                        </li>
                    </ul>
                </nav>
            </div>
            <div class="col-lg-3 text-right d-none d-md-block">
                <!-- <nav class="navbar navbar-expand-sm bg-dark p-0"> -->
                <h6 style="color: white;">ISSN: ${journal.issn}</h6>
                <!-- </nav> -->
            </div>
        </div>
        <div class="row align-items-center bg-white py-3 px-lg-5">
            <div class="col-lg-4">
                <a href="/${journal.domain}/" class="navbar-brand p-0 d-none d-lg-block">
                    <div class="heading-text">
                        <h6>


                            <span style="font-size: 1.2em; font-weight: bold; margin-bottom: 0;">${journal.title.split(' ').take(4).join(' ')}</span><br>
                            <span style="font-weight: bold; margin-top: 0;">${journal.title.split(' ').skip(4).join(' ')} ( ${journal.domain.toUpperCase()} )</span>
                        </h6>

                    </div>


                </a>
            </div>
            <!-- login button -->
            <div class="col-lg-8 text-center text-lg-right">
                <a href="https://admin.abhijournals.com/" target="_blank" class="btn px-4"
                    style="background-color: #033e93; color: white; border-radius: 5px;">Login/Register</a>
            </div>
        </div>
    </div>
    <!-- Topbar End -->


    <!-- Navbar Start -->
    <div class="container-fluid p-0">
        <nav class="navbar navbar-expand-lg bg-dark navbar-dark py-2 py-lg-0 px-lg-5">
            <a href="/${journal.domain}/" class="navbar-brand d-block d-lg-none">
                <div class="">   


                        <span style="font-size: 0.6em; font-weight: bold;color: white;">${journal.title.split(' ').take(5).join(' ')}</span><br>

                        <span style="font-size: 0.6em; font-weight: bold;color: white;">${journal.title.split(' ').skip(5).take(5).join(' ')}</span><br>
                </div>


            </a>
            <a href="https://admin.abhijournals.com/" target="_blank" class="btn px-3 d-block d-lg-none"
                style="background-color: #033e93; color: white; border-radius: 5px; margin-right: 1px;">
                Login
            </a>
            <button type="button" class="navbar-toggler" data-toggle="collapse" data-target="#navbarCollapse">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse justify-content-center px-0 px-lg-3" id="navbarCollapse">
                <div class="navbar-nav mx-auto py-0">
                    <div class="nav-item dropdown">
                        <a
                            class="nav-link dropdown-toggle" data-toggle="dropdown">Browse</a>
                        <div class="dropdown-menu rounded-0 m-0">
                            <a href="/${journal.domain}/current_issue/"
                                class="dropdown-item">Current Issue</a>
                            <a href="/${journal.domain}/by_issue/" class="dropdown-item">By
                                Issue</a>

                        </div>
                    </div>

                    <div class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle"
                            data-toggle="dropdown">Archive</a>
                        <div class="dropdown-menu rounded-0 m-0">
                            {% for year in (journal.get_filtered_volumes_by_year()).keys() %}

                            <a href="/${journal.domain}/archive/${2024}/" class="dropdown-item">Archive
                                ${2024}</a>
                            {% endfor %}


                        </div>
                    </div>

                    <div class="nav-item dropdown">
                        <a 
                            class="nav-link dropdown-toggle" data-toggle="dropdown">Journal
                            Info</a>
                        <div class="dropdown-menu rounded-0 m-0">
                            <a href="/${journal.domain}/about_journal/"
                                class="dropdown-item">About Journal</a>
                            <a href="/${journal.domain}/aim_and_scope/" class="dropdown-item">Aim
                                and Scope</a>

                            <a href="/${journal.domain}/editorial_board/"
                                class="dropdown-item">Editorial Board</a>
                            <a href="/${journal.domain}/publication_ethics/"

                                class="dropdown-item">Publication Ethics</a>
                            <a href="/${journal.domain}/indexing_and_abstracting/"
                                class="dropdown-item">Indexing And Abstracting</a>

                            <a href="/${journal.domain}/peer_review_process/"
                                class="dropdown-item">Peer Review Process</a>
                        </div>

                    </div>

                    <div class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" data-toggle="dropdown">For Author</a>
                        <div class="dropdown-menu rounded-0 m-0">
                            <a href="/${journal.domain}/submit_online_paper/"

                                class="dropdown-item">Submit Online Paper</a>
                            <a href="/${journal.domain}/topic/" class="dropdown-item">Topics</a>
                            <a href="/${journal.domain}/author_guidelines/"
                                class="dropdown-item">Author Guidelines</a>

                            <a href="/${journal.domain}/copyright_form/"
                                class="dropdown-item">Copyright Form</a>
                            <a href="/${journal.domain}/check_paper_status/"

                                class="dropdown-item">Check Paper Status</a>
                            
                        </div>
                    </div>

                    <a href="/${journal.domain}/submit_manuscript/"
                        class="nav-item nav-link">Submit Manuscript</a>
                    <a href="/${journal.domain}/reviewer/" class="nav-item nav-link">Reviewer</a>

                    <a href="/${journal.domain}/contact_us/"
                        class="nav-item nav-link">Contact</a>
                </div>

            </div>
        </nav>
    </div>
    <!-- Navbar End -->


    <!-- Breaking News Start -->
    <div class="container-fluid bg-dark py-3 mb-3">
        <div class="container">
            <div class="row align-items-center bg-dark">
                <div class="col-12">
                    <div class="d-flex justify-content-between">
                        <div class="bg-primary text-dark text-center font-weight-bold py-2 ml-lg-4" style=" width:100%; max-width: 170px;">
                            For Reference
                        </div>
                        <div class="scrolling-text">
                            <div class="scrolling-content">
                                <a href="/${journal.domain}/about_journal/">About Journal</a>
                                <a href="/${journal.domain}/aim_and_scope/">Aim and Scope</a>
                                <a href="/${journal.domain}/editorial_board/">Editorial Board</a>

                                <a href="/${journal.domain}/publication_ethics/">Publication
                                    Ethics</a>
                                <a href="/${journal.domain}/indexing_and_abstracting/">Indexing
                                    And Abstracting</a>
                                <a href="/${journal.domain}/peer_review_process/">Peer Review
                                    Process</a>

                                <!-- Repeat content to ensure smooth looping -->
                                <a href="/${journal.domain}/about_journal/">About Journal</a>
                                <a href="/${journal.domain}/aim_and_scope/">Aim and Scope</a>

                                <a href="/${journal.domain}/editorial_board/">Editorial Board</a>
                                <a href="/${journal.domain}/publication_ethics/">Publication
                                    Ethics</a>

                                <a href="/${journal.domain}/indexing_and_abstracting/">Indexing
                                    And Abstracting</a>
                                <a href="/${journal.domain}/peer_review_process/">Peer Review

                                    Process</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- Breaking News End -->


</body>

</html>
''';
}


String getFooterHtml(JournalModel journal) {
    return '''
<div class="footer bg-dark pt-3 px-sm-3 px-md-5 mt-5">


        <div class="row justify-content-center py-2">
            <div class="col-lg-12 text-center mb-4">
                <h6 class="mb-3 text-white text-uppercase font-weight-bold">Follow Us</h6>
                <div class="d-flex justify-content-center flex-wrap">
                    <a class="btn btn-lg btn-secondary btn-lg-square m-2" href="{{ social_links['x'] }}" id="twitter-link-footer"
                        target="_blank"><i class="fab fa-twitter"></i></a>
                    <a class="btn btn-lg btn-secondary btn-lg-square m-2" href="{{ social_links['facebook'] }}" id="facebook-link-footer"
                        target="_blank"><i class="fab fa-facebook-f"></i></a>
                    <a class="btn btn-lg btn-secondary btn-lg-square m-2" href="{{ social_links['linkedin'] }}" id="linkedin-link-footer"
                        target="_blank"><i class="fab fa-linkedin-in"></i></a>
                    <a class="btn btn-lg btn-secondary btn-lg-square m-2" href="{{ social_links['instagram'] }}" id="instagram-link-footer"
                        target="_blank"><i class="fab fa-instagram"></i></a>
                    <a class="btn btn-lg btn-secondary btn-lg-square m-2" href="{{ social_links['youtube'] }}" id="youtube-link-footer"
                        target="_blank"><i class="fab fa-youtube"></i></a>
                </div>
            </div>
        </div>
        
        <div class="row py-1">
            <div class="col-md-6 text-center text-md-left">
                <h5 class="mb-3 text-white text-uppercase font-weight-bold">Get In Touch</h5>
                <div class="d-flex flex-column">
                    <p class="font-weight-medium mb-2"><i class="fa fa-map-marker-alt mr-2"></i>Vitthal Namdev Nagar,
                        Opp Jain Temple Sanganer Sanganer Bazar Jaipur 302029 Rajasthan (India)</p>
                    <p class="font-weight-medium mb-2"><i class="fa fa-phone-alt mr-2"></i>+91-9799997157</p>
                    <p class="font-weight-medium mb-0"><i class="fa fa-envelope mr-2"></i>mail@abhijournals.com</p>
                </div>
            </div>
        </div>
    </div>

    <div class="footer-2 py-4 px-sm-3 px-md-5" style="background: #111111;">
        <p class="m-0 text-center">&copy; <a href="#">Abhi Journals</a>. All Rights Reserved.
        </p>
    </div>
    <!-- Footer End -->


    <!-- Back to Top -->
    <a href="#" class="btn btn-primary btn-square back-to-top"><i class="fa fa-arrow-up"></i></a>


    <!-- JavaScript Libraries -->
    <script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.bundle.min.js"></script>
    <script src="lib/easing/easing.min.js"></script>
    <script src="lib/owlcarousel/owl.carousel.min.js"></script>


    <!-- Template Javascript -->
    <script src="js/main.js"></script>

''';
}
