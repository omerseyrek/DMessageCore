FROM microsoft/dotnet:2.2-sdk AS build-env
WORKDIR /app


COPY *.csproj ./
RUN dotnet restore

# Copy everything else and build
COPY ./ ./
RUN dotnet publish DMessageCore.csproj -c Release -o out


# Build runtime image
FROM  microsoft/dotnet:2.2-aspnetcore-runtime
WORKDIR /app
ENV ASPNETCORE_URLS=http://*:8080
COPY --from=build-env /app/out .

EXPOSE  8080
ENTRYPOINT ["dotnet", "DMessageCore.dll"]