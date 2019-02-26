clear all;
EbNo_dB = 0:1:12;
EbNo_lin = 10.^(EbNo_dB/10);
inputNum = 10^(6); %no. of input to be tested for each SNR (prefer even number)
ber = zeros(length(EbNo_dB),1);
so = zeros(inputNum,1);

for u=1:length(EbNo_dB)
    %for u=1:1
    %clean variable
    %syms inputseq siI siQ si sigma n m soI soQ so berI berQ
    
    %generate input signal
    inputseq = randi([0 1],inputNum,1);%random bit seq as input
    siI = inputseq(1:2:end); %odd element
    siQ = inputseq(2:2:end); %even element
    
    %replace 0 as -1
    siI(siI == 0) = -1;
    siQ(siQ == 0) = -1;
    
    si = siI + 1j*siQ;

    %generate noise
    sigma=sqrt(1/(2*EbNo_lin(u)));%SNR in linear
    n=sigma*(randn(length(si),1)+1i*randn(length(si),1));
    
    %transmitted signal
    m = si + n;
    
    %receiver
    soI=sign(real(m));
    soQ=sign(imag(m));%compare with threshold zero
    
    %so((1:length(soI))*2 - 1) = soI; %received bit stream(1 & -1)
    %so((1:length(soQ))*2) = soQ;%received bit stream(1 & -1)
    
    %compute BER
    I=siI + soI;
    Q=siQ + soQ;
    berI = sum(I(:)== 0)/length(I); %if sum equals to one, transmission error has occurred
    berQ = sum(Q(:)== 0)/length(Q);
    ber(u) = mean([berI berQ]);%if sum equals to zero, transmission error has occurred
    disp(u)
end

figure(1);
semilogy(EbNo_dB,ber)
grid on
hold on

BER_QPSK = berawgn(EbNo_dB,'psk',4,'nondiff');
semilogy(EbNo_dB,BER_QPSK)
grid on
hold on

xlabel('EbNo(dB)');
ylabel('Bit Error Rate');
set(findall(gca, 'Type', 'Line'),'LineWidth',1);


title('Performance of QPSK simulation model');
legend({'Simulation QPSK','Theoretical QPSK'});


%----------------------------theoretical graphs-------------------------------------
% %BER of BPSK/QPSK in AWGN channel
% %QPSK & BPSK same bit error rate, different symbol error rate

figure(2);

EbNo_dB = 0:1:60;

BER_BPSK = berawgn(EbNo_dB,'psk',2,'nondiff');
semilogy(EbNo_dB,BER_BPSK)
grid on
hold on

BER_QPSK = berawgn(EbNo_dB,'psk',4,'nondiff');
semilogy(EbNo_dB,BER_QPSK)
grid on
hold on

BER_16QAM = berawgn(EbNo_dB,'qam',16);
semilogy(EbNo_dB,BER_16QAM)
grid on
hold on

xlabel('EbNo(dB)');
ylabel('Bit Error Rate');
set(findall(gca, 'Type', 'Line'),'LineWidth',1);


title('Theoretical Error Probability for BPSK, QPSK and 16QAM in AWGN');
legend({'BPSK','QPSK','16QAM'})



%----------------------------Rayleigh fading----------------------

figure(3);

EbNo_dB = 0:2:150;

BER_QPSK = berawgn(EbNo_dB,'psk',4,'nondiff');
semilogy(EbNo_dB,BER_QPSK)
grid on
hold on

BER_16QAM = berawgn(EbNo_dB,'qam',16);
semilogy(EbNo_dB,BER_16QAM)
grid on
hold on

BER_QPSK_RAY = berfading(EbNo_dB,'psk',4,1);
semilogy(EbNo_dB,BER_QPSK_RAY)
grid on
hold on

BER_16QAM_RAY = berfading(EbNo_dB,'qam',16,1);
semilogy(EbNo_dB,BER_16QAM_RAY)
grid on
hold on

xlabel('EbNo(dB)');
ylabel('Bit Error Rate');
set(findall(gca, 'Type', 'Line'),'LineWidth',1);


title('Performance of QPSK and 16QAM in Rayleigh Fading');
legend({'QPSK','16QAM','QPSK in Rayleigh Fading','16QAM in Rayleigh Fading'})