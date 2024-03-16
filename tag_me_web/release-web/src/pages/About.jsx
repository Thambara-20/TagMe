import Aos from "aos";
import React from "react";
import { useEffect } from "react";
import styled from "styled-components";
import AboutImg from "../assets/images/about.png";

const AboutPageContainer = styled.div`
  padding: 20px;
  margin: 20px auto;
  max-width: 1200px;
  display: flex;
  flex-direction: row;
  justify-content: space-between;
  align-items: center;
  @media (max-width: 768px) {
    flex-direction: column;
  }
`;
const ImageContainer = styled.div`
  flex: 1;
  justify-content: space-between;
  align-items: center;
  img {
    width: 100%;
    height: auto;
    border-radius: 8px;
  }
`;

const ContentContainer = styled.div`
  flex: 2;
  padding: 0 20px;
  flex-direction: row;
  text-align: center;
  justify-content: center;
  align-content: center;
  align-items: center;
  @media (max-width: 767px) {
    margin-top: 20px;
  }
`;

const SectionTitle = styled.h2`
  color: #007bff;
  margin-bottom: 20px;
  margin-top: 20px;
`;

const About = () => {
      // initialize AOS
  useEffect(() => {
    Aos.init({
      duration: 1000,
    });
  }, []);
  return (
    <AboutPageContainer data-aos='fade-up'>
      <ImageContainer>
        <img
          src={AboutImg} // Placeholder image URL
          alt="About Tag Me"
        />
      </ImageContainer>
      <ContentContainer>
        <div
          style={{
            padding: "10px 15px 10px 15px",
            display: "flex",
            flexDirection: "column",
            alignContent: "center",
          }}
        >
          <SectionTitle>About Tag Me</SectionTitle>
          <p>
            Welcome to Tag Me - the innovative app designed to simplify
            attendance tracking for various events and activities. With a
            user-friendly interface and robust features, Tag Me makes it easy
            for users to mark their attendance accurately.
          </p>
          <p>
            Our mission is to provide a seamless and efficient solution for
            managing attendance, making it a breeze for event organizers and participants alike.
          </p>
          <SectionTitle>Key Features</SectionTitle>
          <ul style={{ listStyleType: "none", padding: 0 }}>
            <li>Effortless attendance tracking based on the user's location</li>
            <li>User-friendly interface</li>
            <li>Reliable and accurate results</li>
            {/* Add more key features */}
          </ul>
          <SectionTitle>Contact Us</SectionTitle>
          <p>
            Have questions and feedbacks? Reach out to us at{" "}
            <a href="mailto:info@tagme-app.com">uomleoclub@gmail.com</a>.
          </p>
        </div>
      </ContentContainer>
    </AboutPageContainer>
  );
};

export default About;
